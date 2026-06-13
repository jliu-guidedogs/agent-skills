@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "REPO_ROOT=%SCRIPT_DIR%.."
for %%I in ("%REPO_ROOT%") do set "REPO_ROOT=%%~fI"
set "SKILLS_SRC=%REPO_ROOT%\skills"

set "WITH_OPTIONAL=0"

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

set "CURSOR_SKILLS=%USERPROFILE%\.cursor\skills"
set "CLAUDE_SKILLS=%USERPROFILE%\.claude\skills"
set "AGENTS_SKILLS=%USERPROFILE%\.agents\skills"

call :install_target "%CURSOR_SKILLS%"
if errorlevel 1 exit /b 1
call :install_target "%CLAUDE_SKILLS%"
if errorlevel 1 exit /b 1
call :install_target "%AGENTS_SKILLS%"
if errorlevel 1 exit /b 1

echo Done. Restart Cursor, Claude Code, or start a new agent session to pick up skills.
exit /b 0

:install_target
set "TARGET_ROOT=%~1"
if not exist "%TARGET_ROOT%" mkdir "%TARGET_ROOT%"

call :link_skill thought-companion "%TARGET_ROOT%"
if errorlevel 1 exit /b 1
call :link_skill brainstorm-diverge-converge "%TARGET_ROOT%"
if errorlevel 1 exit /b 1
call :link_skill socratic "%TARGET_ROOT%"
if errorlevel 1 exit /b 1
call :link_skill decision-helper "%TARGET_ROOT%"
if errorlevel 1 exit /b 1
call :link_skill idea-evaluator "%TARGET_ROOT%"
if errorlevel 1 exit /b 1
call :link_skill grill-me "%TARGET_ROOT%"
if errorlevel 1 exit /b 1
call :link_skill deep-understanding "%TARGET_ROOT%"
if errorlevel 1 exit /b 1
call :link_skill handoff "%TARGET_ROOT%"
if errorlevel 1 exit /b 1

if "%WITH_OPTIONAL%"=="1" (
  call :link_skill graphify "%TARGET_ROOT%"
  if errorlevel 1 exit /b 1
)
exit /b 0

:link_skill
set "NAME=%~1"
set "TARGET_ROOT=%~2"
set "SKILL_SRC=%SKILLS_SRC%\%NAME%"
set "LINK_PATH=%TARGET_ROOT%\%NAME%"

if not exist "%SKILL_SRC%\SKILL.md" (
  echo warning: missing %SKILL_SRC%\SKILL.md 1>&2
  exit /b 0
)

if exist "%LINK_PATH%" (
  rmdir "%LINK_PATH%" 2>nul
)

mklink /J "%LINK_PATH%" "%SKILL_SRC%" >nul 2>&1
if !ERRORLEVEL! equ 0 (
  echo linked %NAME% -^> %LINK_PATH%
  exit /b 0
)

mklink /D "%LINK_PATH%" "%SKILL_SRC%" >nul 2>&1
if !ERRORLEVEL! equ 0 (
  echo linked %NAME% -^> %LINK_PATH%
  exit /b 0
)

echo error: could not link %NAME% to %LINK_PATH% 1>&2
echo        Enable Developer Mode ^(Settings ^> System ^> For developers^) or run this script as Administrator. 1>&2
exit /b 1

:usage
echo Usage: %~nx0 [--with-optional]
echo.
echo Install agent skills from %SKILLS_SRC% into:
echo   %%USERPROFILE%%\.cursor\skills   ^(Cursor^)
echo   %%USERPROFILE%%\.claude\skills    ^(Claude Code^)
echo   %%USERPROFILE%%\.agents\skills   ^(Codex / shared agents^)
echo.
echo   --with-optional   Also install optional skills ^(graphify^)
echo   --with-graphify   Alias for --with-optional
echo   -h, --help        Show this help
exit /b 0

:usage_fail
call :usage
exit /b 1
