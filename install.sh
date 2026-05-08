#!/bin/bash

# MikeCibGPT Installer para Linux y Termux
set -u

export LC_ALL="${LC_ALL:-C.UTF-8}"
export LANG="${LANG:-C.UTF-8}"
export PYTHONUTF8=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

echo "======================================"
echo "    MikeCibGPT Installer Script"
echo "======================================"

# Detectar gestor de paquetes
detect_pkg_manager() {
    if command -v apt-get &> /dev/null; then
        echo "apt"
    elif command -v pkg &> /dev/null; then
        echo "pkg"
    else
        echo "unknown"
    fi
}

PKG_MANAGER=$(detect_pkg_manager)

if command -v python3 &> /dev/null; then
    PYTHON_CMD="python3"
elif command -v python &> /dev/null; then
    PYTHON_CMD="python"
else
    PYTHON_CMD=""
fi

if [ -z "$PYTHON_CMD" ]; then
    # Instalar dependencias del sistema solo si Python no existe
    echo "[+] Python no encontrado. Intentando instalarlo..."
    if [ "$PKG_MANAGER" = "apt" ]; then
        if command -v sudo &> /dev/null; then
            SUDO_CMD="sudo"
        else
            SUDO_CMD=""
        fi
        $SUDO_CMD apt-get update -y
        echo "[+] Instalando python3 y pip..."
        $SUDO_CMD apt-get install python3 python3-pip -y
        PYTHON_CMD="python3"
    elif [ "$PKG_MANAGER" = "pkg" ]; then
        pkg update -y
        echo "[+] Instalando python..."
        pkg install python -y
        PYTHON_CMD="python"
    else
        echo "[!] Gestor de paquetes no soportado. Instala python3 y pip manualmente."
        exit 1
    fi
else
    echo "[+] Python encontrado: $PYTHON_CMD"
fi

if [ ! -f "requirements.txt" ]; then
    echo "[!] No se encontro requirements.txt en:"
    echo "    $PWD"
    exit 1
fi

if [ ! -f "MikeCibGPT.py" ]; then
    echo "[!] No se encontro MikeCibGPT.py en:"
    echo "    $PWD"
    exit 1
fi

# Instalar dependencias Python
echo "[+] Instalando dependencias Python..."
if ! "$PYTHON_CMD" -m pip --version &> /dev/null; then
    echo "[!] pip no esta disponible para $PYTHON_CMD."
    echo "[!] Instala pip manualmente y vuelve a ejecutar este script."
    exit 1
fi

if ! "$PYTHON_CMD" -m pip install -r requirements.txt; then
    echo "[!] No se pudieron instalar las dependencias."
    echo "[!] Revisa tu conexion o ejecuta manualmente:"
    echo "    $PYTHON_CMD -m pip install -r requirements.txt"
    exit 1
fi

echo ""
echo "======================================"
echo "      Instalacion completa!"
echo "======================================"
echo "Obten tu API Key gratis en: https://openrouter.ai/keys"
echo "======================================"
echo ""
echo "[+] Abriendo MikeCibGPT..."
echo ""

if ! "$PYTHON_CMD" MikeCibGPT.py; then
    echo ""
    echo "[!] MikeCibGPT se cerro con un error."
    exit 1
fi
