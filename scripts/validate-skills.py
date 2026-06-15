#!/usr/bin/env python3
"""Validate repository skill frontmatter without third-party dependencies."""

from __future__ import annotations

import re
import sys
from pathlib import Path


ALLOWED_KEYS = {
    "name",
    "description",
    "license",
    "allowed-tools",
    "metadata",
    "user-invocable",
    "disable-model-invocation",
    "argument-hint",
    "trigger",
}
NAME_PATTERN = re.compile(r"^[a-z0-9]+(?:-[a-z0-9]+)*$")
KEY_PATTERN = re.compile(r"^([A-Za-z0-9_-]+):(?:\s*(.*))?$")


def parse_frontmatter(path: Path) -> dict[str, str]:
    lines = path.read_text(encoding="utf-8").splitlines()
    if not lines or lines[0] != "---":
        raise ValueError("missing opening YAML delimiter")

    try:
        end = lines.index("---", 1)
    except ValueError as exc:
        raise ValueError("missing closing YAML delimiter") from exc

    values: dict[str, str] = {}
    block_key: str | None = None

    for line in lines[1:end]:
        if not line.strip() or line.lstrip().startswith("#"):
            continue

        if line[0].isspace():
            if block_key is not None:
                text = line.strip()
                if text:
                    values[block_key] = " ".join(
                        part for part in (values[block_key], text) if part
                    )
            continue

        match = KEY_PATTERN.match(line)
        if not match:
            raise ValueError(f"unsupported frontmatter line: {line!r}")

        key, raw_value = match.groups()
        raw_value = (raw_value or "").strip()
        values[key] = "" if raw_value in {"|", ">"} else unquote(raw_value)
        block_key = key if raw_value in {"|", ">"} else None

    return values


def unquote(value: str) -> str:
    if len(value) >= 2 and value[0] == value[-1] and value[0] in {'"', "'"}:
        return value[1:-1]
    return value


def validate_skill(path: Path) -> list[str]:
    skill_file = path / "SKILL.md"
    if not skill_file.is_file():
        return [f"{path}: SKILL.md not found"]

    try:
        frontmatter = parse_frontmatter(skill_file)
    except ValueError as exc:
        return [f"{skill_file}: {exc}"]

    errors: list[str] = []
    unknown = sorted(set(frontmatter) - ALLOWED_KEYS)
    if unknown:
        errors.append(f"{skill_file}: unexpected keys: {', '.join(unknown)}")

    name = frontmatter.get("name", "").strip()
    description = frontmatter.get("description", "").strip()

    if not name:
        errors.append(f"{skill_file}: missing name")
    elif not NAME_PATTERN.fullmatch(name):
        errors.append(f"{skill_file}: invalid hyphen-case name {name!r}")
    elif name != path.name:
        errors.append(
            f"{skill_file}: name {name!r} does not match folder {path.name!r}"
        )

    if not description:
        errors.append(f"{skill_file}: missing description")
    elif len(description) > 1024:
        errors.append(f"{skill_file}: description exceeds 1024 characters")
    elif "<" in description or ">" in description:
        errors.append(f"{skill_file}: description contains angle brackets")

    return errors


def resolve_skill_paths(arguments: list[str]) -> list[Path]:
    if arguments:
        roots = [Path(argument) for argument in arguments]
    else:
        roots = [Path(__file__).resolve().parents[1] / "skills"]

    paths: list[Path] = []
    for root in roots:
        if (root / "SKILL.md").is_file():
            paths.append(root)
        elif root.is_dir():
            paths.extend(
                child for child in sorted(root.iterdir()) if (child / "SKILL.md").is_file()
            )
        else:
            raise ValueError(f"skill path not found: {root}")
    return paths


def main() -> int:
    try:
        paths = resolve_skill_paths(sys.argv[1:])
    except ValueError as exc:
        print(exc, file=sys.stderr)
        return 2

    errors = [error for path in paths for error in validate_skill(path)]
    if errors:
        print("\n".join(errors), file=sys.stderr)
        return 1

    print(f"Validated {len(paths)} skill(s).")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
