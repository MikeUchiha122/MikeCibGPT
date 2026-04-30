#!/bin/bash

# MikeCibGPT Installer para Linux y Termux
export LC_ALL="${LC_ALL:-C.UTF-8}"
export LANG="${LANG:-C.UTF-8}"
export PYTHONUTF8=1

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

# Instalar dependencias del sistema
echo "[+] Actualizando listas de paquetes..."
if [ "$PKG_MANAGER" = "apt" ]; then
    sudo apt-get update -y
    echo "[+] Instalando python3 y pip..."
    sudo apt-get install python3 python3-pip -y
elif [ "$PKG_MANAGER" = "pkg" ]; then
    pkg update -y
    echo "[+] Instalando python..."
    pkg install python -y
else
    echo "[!] Gestor de paquetes no soportado. Instala python3 y pip manualmente."
    exit 1
fi

# Instalar dependencias Python (desde el directorio actual)
echo "[+] Instalando dependencias Python..."
if command -v pip3 &> /dev/null; then
    pip3 install -r requirements.txt
else
    pip install -r requirements.txt
fi

echo ""
echo "======================================"
echo "      Instalacion completa!"
echo "======================================"
echo "Para ejecutar MikeCibGPT:"
echo ""
echo "  python3 MikeCibGPT.py"
echo ""
echo "Obten tu API Key gratis en: https://openrouter.ai/keys"
echo "======================================"
