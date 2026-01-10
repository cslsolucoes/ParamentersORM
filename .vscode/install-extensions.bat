@echo off
setlocal enabledelayedexpansion
REM Script para Instalar Extensões Recomendadas do Cursor/VSCode
REM Data: 02/01/2026
REM Versão: 1.0.0

echo.
echo ================================================================
echo 🚀 Instalando Extensões Recomendadas para Free Pascal/Delphi
echo ================================================================
echo.

REM Detectar se é Cursor ou VSCode
where cursor >nul 2>nul
if %ERRORLEVEL% == 0 (
    set CODE_CMD=cursor
    echo ✅ Cursor detectado!
    goto :install
)

where code >nul 2>nul
if %ERRORLEVEL% == 0 (
    set CODE_CMD=code
    echo ✅ VSCode detectado!
    goto :install
)

echo ❌ Erro: Cursor ou VSCode não encontrado no PATH!
echo    Por favor, adicione o Cursor ou VSCode ao PATH do sistema.
pause
exit /b 1

:install
echo.
echo Instalando extensões...
echo.

set INSTALLED=0
set FAILED=0
set SKIPPED=0

REM Instalar cada extensão individualmente
call :install_ext "alefragnani.pascal"
call :install_ext "alefragnani.project-manager"
call :install_ext "alefragnani.pascal-formatter"
call :install_ext "alefragnani.delphi-keybindings"
call :install_ext "embarcaderotechnologies.delphilsp"
call :install_ext "theangryepicbanana.language-pascal"
call :install_ext "formulahendry.code-runner"
call :install_ext "github.vscode-pull-request-github"
call :install_ext "eamodio.gitlens"
call :install_ext "mhutchie.git-graph"
call :install_ext "vmssoftwareinc.vms-ide"

echo.
echo ================================================================
echo 📊 Resumo da Instalação
echo ================================================================
echo ✅ Instaladas: !INSTALLED!
echo ⏭️  Já instaladas: !SKIPPED!
echo ❌ Falhas: !FAILED!
echo.

if !FAILED! == 0 (
    echo 🎉 Todas as extensões foram processadas com sucesso!
    echo.
    echo 💡 Dica: Recarregue a janela do Cursor/VSCode para ativar as extensões:
    echo    Pressione Ctrl+Shift+P e digite 'Reload Window'
) else (
    echo ⚠️  Algumas extensões falharam. Isso é normal se algumas não estiverem disponíveis.
    echo    Verifique quais extensões você realmente precisa.
)

echo.
pause
endlocal
exit /b 0

:install_ext
set "EXT_ID=%~1"
echo 📦 Instalando: %EXT_ID%

REM Verificar se já está instalada
%CODE_CMD% --list-extensions 2>nul | findstr /C:"%EXT_ID%" >nul
if !ERRORLEVEL! == 0 (
    echo    [⏭️  JÁ INSTALADA]
    set /a SKIPPED+=1
    goto :end_install
)

REM Tentar instalar
%CODE_CMD% --install-extension %EXT_ID% --force 2>nul
if !ERRORLEVEL! == 0 (
    echo    [✅ OK]
    set /a INSTALLED+=1
) else (
    echo    [❌ FALHOU - Extensão não encontrada ou erro na instalação]
    set /a FAILED+=1
)

:end_install
timeout /t 1 /nobreak >nul 2>nul
exit /b
