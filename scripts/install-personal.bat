@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "REPO_ROOT=%SCRIPT_DIR%.."
for %%I in ("%REPO_ROOT%") do set "REPO_ROOT=%%~fI"
set "SKILLS_SRC=%REPO_ROOT%\skills"

set "WITH_OPTIONAL=0"
set "LINK_OK=0"
set "COPY_OK=0"
set "LINK_FAIL=0"
set "LINK_SKIP=0"

:parse_args
if "%~1"=="" goto args_done
if /I "%~1"=="--with-optional" set "WITH_OPTIONAL=1" & shift & goto parse_args
if /I "%~1"=="--with-graphify" set "WITH_OPTIONAL=1" & shift & goto parse_args
if /I "%~1"=="-h" goto usage
if /I "%~1"=="--help" goto usage
echo Unknown option: %~1 1>&2
goto usage_fail
:args_done

set "CORE_COUNT=8"
echo Installing core thinking stack (%CORE_COUNT% skills)...
if "%WITH_OPTIONAL%"=="1" (
  echo Including optional skills: graphify
)
echo Errors are reported but installation continues for remaining skills.
echo.

set "CURSOR_SKILLS=%USERPROFILE%\.cursor\skills"
set "CLAUDE_SKILLS=%USERPROFILE%\.claude\skills"
set "AGENTS_SKILLS=%USERPROFILE%\.agents\skills"

call :install_target "%CURSOR_SKILLS%"
call :install_target "%CLAUDE_SKILLS%"
call :install_target "%AGENTS_SKILLS%"

echo.
echo Installation finished.
echo   linked:  !LINK_OK!
echo   copied:  !COPY_OK!
echo   failed:  !LINK_FAIL!
echo   skipped: !LINK_SKIP!
if !LINK_FAIL! gtr 0 (
  echo.
  echo Some skills could not be installed. Common fixes:
  echo   - Enable Developer Mode ^(Settings ^> System ^> For developers^) for symlinks
  echo   - Run this script as Administrator
  echo   - Remove blocking folders at the failed paths and re-run
  echo.
  echo Restart Cursor, Claude Code, or start a new agent session for installed skills.
  exit /b 1
)

if !COPY_OK! gtr 0 (
  echo.
  echo Note: copied skills are snapshots. Re-run this script after updating the repo
  echo       to refresh copies, or enable symlinks for live updates.
)

echo Done. Restart Cursor, Claude Code, or start a new agent session to pick up skills.
exit /b 0

:install_target
set "TARGET_ROOT=%~1"
echo === %TARGET_ROOT% ===
if not exist "%TARGET_ROOT%" mkdir "%TARGET_ROOT%" 2>nul
if not exist "%TARGET_ROOT%" (
  echo warning: could not create %TARGET_ROOT% — skipping this target 1>&2
  exit /b 0
)

call :link_skill thought-companion "%TARGET_ROOT%"
call :link_skill brainstorm-diverge-converge "%TARGET_ROOT%"
call :link_skill socratic "%TARGET_ROOT%"
call :link_skill decision-helper "%TARGET_ROOT%"
call :link_skill idea-evaluator "%TARGET_ROOT%"
call :link_skill grill-me "%TARGET_ROOT%"
call :link_skill deep-understanding "%TARGET_ROOT%"
call :link_skill handoff "%TARGET_ROOT%"
call :link_skill grill-architecture-decisions "%TARGET_ROOT%"

if "%WITH_OPTIONAL%"=="1" (
  call :link_skill graphify "%TARGET_ROOT%"
)
exit /b 0

:link_skill
set "NAME=%~1"
set "TARGET_ROOT=%~2"
set "SKILL_SRC=%SKILLS_SRC%\%NAME%"
set "LINK_PATH=%TARGET_ROOT%\%NAME%"

if not exist "%SKILL_SRC%\SKILL.md" (
  echo warning: missing %SKILL_SRC%\SKILL.md — skipped %NAME% 1>&2
  set /a LINK_SKIP+=1
  exit /b 0
)

call :remove_path "%LINK_PATH%"
if errorlevel 1 (
  echo warning: could not remove existing %LINK_PATH% — skipping %NAME% 1>&2
  set /a LINK_FAIL+=1
  exit /b 0
)

mklink /J "%LINK_PATH%" "%SKILL_SRC%" >nul 2>&1
if !ERRORLEVEL! equ 0 (
  echo linked %NAME% -^> %LINK_PATH%
  set /a LINK_OK+=1
  exit /b 0
)

mklink /D "%LINK_PATH%" "%SKILL_SRC%" >nul 2>&1
if !ERRORLEVEL! equ 0 (
  echo linked %NAME% -^> %LINK_PATH%
  set /a LINK_OK+=1
  exit /b 0
)

call :copy_skill "%SKILL_SRC%" "%LINK_PATH%" "%NAME%"
exit /b 0

:remove_path
set "PATH_TO_REMOVE=%~1"
if not exist "%PATH_TO_REMOVE%" exit /b 0
rmdir "%PATH_TO_REMOVE%" 2>nul
if not exist "%PATH_TO_REMOVE%" exit /b 0
rmdir /s /q "%PATH_TO_REMOVE%" 2>nul
if exist "%PATH_TO_REMOVE%" exit /b 1
exit /b 0

:copy_skill
set "COPY_SRC=%~1"
set "COPY_DEST=%~2"
set "COPY_NAME=%~3"

mkdir "%COPY_DEST%" 2>nul
robocopy "%COPY_SRC%" "%COPY_DEST%" /E /NFL /NDL /NJH /NJS /nc /ns /np /R:1 /W:1 >nul
set "ROBOCODE=!ERRORLEVEL!"
if !ROBOCODE! GEQ 8 (
  echo warning: could not copy %COPY_NAME% to %COPY_DEST% — continuing 1>&2
  set /a LINK_FAIL+=1
  exit /b 0
)

if not exist "%COPY_DEST%\SKILL.md" (
  echo warning: copy of %COPY_NAME% is missing SKILL.md — continuing 1>&2
  set /a LINK_FAIL+=1
  exit /b 0
)

echo copied %COPY_NAME% -^> %COPY_DEST% ^(link failed; using folder copy^)
set /a COPY_OK+=1
exit /b 0

:usage
echo Usage: %~nx0 [--with-optional]
echo.
echo Install agent skills from %SKILLS_SRC% into:
echo   %%USERPROFILE%%\.cursor\skills   ^(Cursor^)
echo   %%USERPROFILE%%\.claude\skills    ^(Claude Code^)
echo   %%USERPROFILE%%\.agents\skills   ^(Codex / shared agents^)
echo.
echo Tries symlinks first, then copies skill folders if linking fails.
echo Continues on errors and prints a summary at the end.
echo.
echo   --with-optional   Also install optional skills ^(graphify^)
echo   --with-graphify   Alias for --with-optional
echo   -h, --help        Show this help
exit /b 0

:usage_fail
call :usage
exit /b 1
