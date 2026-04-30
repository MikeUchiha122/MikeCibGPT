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

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
ENV_FILE = os.path.join(BASE_DIR, ".MikeCib")
API_KEY_NAME = "MikeCibGPT-API"
OPENROUTER_API_KEY_NAME = "MikeCibGPT-API-OPENROUTER"
MODELS_URL = "https://openrouter.ai/api/v1/models"


def is_free_model(model: dict) -> bool:
    model_id = model.get("id", "")
    pricing = model.get("pricing", {})

    return model_id.endswith(":free") or (
        str(pricing.get("prompt", "1")) == "0" and
        str(pricing.get("completion", "1")) == "0"
    )


def load_api_key() -> str:
    load_dotenv(dotenv_path=ENV_FILE)
    return os.getenv(OPENROUTER_API_KEY_NAME) or os.getenv(API_KEY_NAME, "")


def fetch_models(api_key: str) -> list:
    headers = {"Authorization": f"Bearer {api_key}"}
    response = requests.get(MODELS_URL, headers=headers, timeout=15)
    response.raise_for_status()
    return response.json().get("data", [])


def main():
    api_key = load_api_key()
    if not api_key:
        print("[!] API Key no encontrada en .MikeCib")
        print("    Ejecuta MikeCibGPT.py primero para configurar tu clave.")
        sys.exit(1)

    print("[*] Consultando modelos gratuitos en OpenRouter...\n")

    try:
        data = fetch_models(api_key)
    except requests.RequestException as e:
        print(f"[!] Error de conexion: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"[!] Error inesperado: {e}")
        sys.exit(1)

    free_models = [m.get("id", "") for m in data if is_free_model(m)]

    if not free_models:
        print("[!] No se encontraron modelos gratuitos.")
        return

    print(f"[+] {len(free_models)} modelos gratuitos encontrados:\n")
    for model in sorted(free_models):
        print(f"  {model}")


if __name__ == "__main__":
    main()
