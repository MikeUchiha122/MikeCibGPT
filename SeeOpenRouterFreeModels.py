# -*- coding: utf-8 -*-
"""
Utilidad para listar todos los modelos gratuitos disponibles en OpenRouter.
Lee la API Key desde el archivo de configuracion .MikeCib
"""
import os
import sys

try:
    import requests
except ImportError:
    print("[!] Falta el paquete 'requests'. Instala con: pip install requests")
    sys.exit(1)

try:
    from dotenv import load_dotenv
except ImportError:
    print("[!] Falta el paquete 'python-dotenv'. Instala con: pip install python-dotenv")
    sys.exit(1)

# Cargar API Key desde .MikeCib (mismo directorio que este script)
ENV_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), ".MikeCib")
load_dotenv(dotenv_path=ENV_FILE)
API_KEY = os.getenv("MikeCibGPT-API", "")

if not API_KEY:
    print("[!] API Key no encontrada en .MikeCib")
    print("    Ejecuta MikeCibGPT.py primero para configurar tu clave.")
    sys.exit(1)

URL = "https://openrouter.ai/api/v1/models"
headers = {"Authorization": f"Bearer {API_KEY}"}

print("[*] Consultando modelos gratuitos en OpenRouter...\n")

try:
    response = requests.get(URL, headers=headers, timeout=15)
    response.raise_for_status()
    data = response.json().get("data", [])
except requests.RequestException as e:
    print(f"[!] Error de conexion: {e}")
    sys.exit(1)
except Exception as e:
    print(f"[!] Error inesperado: {e}")
    sys.exit(1)

free_models = []

for m in data:
    model_id = m.get("id", "")
    pricing = m.get("pricing", {})

    is_free_suffix = model_id.endswith(":free")
    is_free_pricing = (
        str(pricing.get("prompt", "1")) == "0" and
        str(pricing.get("completion", "1")) == "0"
    )

    if is_free_suffix or is_free_pricing:
        free_models.append(model_id)

if not free_models:
    print("[!] No se encontraron modelos gratuitos.")
else:
    print(f"[+] {len(free_models)} modelos gratuitos encontrados:\n")
    for model in sorted(free_models):
        print(f"  {model}")
