@echo off
title MikeCibGPT Installer

cd /d "%~dp0"

echo ======================================
echo     MikeCibGPT Installer for Windows
echo ======================================

:: Check for Git (optional for local execution)
echo [~] Verificando Git...
git --version >nul 2>nul
if errorlevel 1 (
    echo [!] Git no esta instalado o no esta en el PATH.
    echo [!] Continuando: Git no es necesario para abrir MikeCibGPT localmente.
) else (
    echo [+] Git encontrado.
)

:: Check for Python
echo [~] Verificando Python...
set "PYTHON_CMD=python"
%PYTHON_CMD% --version >nul 2>nul
if errorlevel 1 (
    set "PYTHON_CMD=py -3"
    %PYTHON_CMD% --version >nul 2>nul
)
if errorlevel 1 (
    echo [!] Python no esta instalado o no esta en el PATH.
    echo [!] Instala Python desde https://www.python.org/downloads/ y marca "Add Python to PATH".
    pause
    exit /b 1
)
echo [+] Python encontrado.

if not exist "requirements.txt" (
    echo [!] No se encontro requirements.txt en:
    echo     %cd%
    pause
    exit /b 1
)

if not exist "MikeCibGPT.py" (
    echo [!] No se encontro MikeCibGPT.py en:
    echo     %cd%
    pause
    exit /b 1
)

:: Install Python requirements
echo [+] Instalando dependencias Python...
%PYTHON_CMD% -m pip install -r requirements.txt
if errorlevel 1 (
    echo [!] No se pudieron instalar las dependencias.
    echo [!] Revisa tu conexion o ejecuta manualmente:
    echo     %PYTHON_CMD% -m pip install -r requirements.txt
    pause
    exit /b 1
)

echo.
echo ======================================
echo       Instalacion completa!
echo ======================================
echo No olvides obtener tu API Key en https://openrouter.ai/keys
echo ======================================
echo.
echo [+] Abriendo MikeCibGPT...
echo.
%PYTHON_CMD% MikeCibGPT.py
if errorlevel 1 (
    echo.
    echo [!] MikeCibGPT se cerro con un error.
)
pause
