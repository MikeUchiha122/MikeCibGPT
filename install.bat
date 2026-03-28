@echo off
title MikeCibGPT Installer

echo ======================================
echo     MikeCibGPT Installer for Windows
echo ======================================

:: Check for Git
echo [~] Verificando Git...
git --version >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] Git no esta instalado o no esta en el PATH.
    echo [!] Instala Git desde https://git-scm.com/download/win e intenta de nuevo.
    pause
    exit /b
)
echo [+] Git encontrado.

:: Check for Python
echo [~] Verificando Python...
python --version >nul 2>nul
if %errorlevel% neq 0 (
    echo [!] Python no esta instalado o no esta en el PATH.
    echo [!] Instala Python desde https://www.python.org/downloads/ y marca "Add Python to PATH".
    pause
    exit /b
)
echo [+] Python encontrado.

:: Install Python requirements (desde el directorio actual)
echo [+] Instalando dependencias Python...
python -m pip install -r requirements.txt

echo.
echo ======================================
echo       Instalacion completa!
echo ======================================
echo Para ejecutar MikeCibGPT:
echo.
echo python MikeCibGPT.py
echo.
echo No olvides obtener tu API Key en https://openrouter.ai/keys
echo ======================================
pause
