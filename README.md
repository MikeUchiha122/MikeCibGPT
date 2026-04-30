# MikeCibGPT

<p align="center">
  <img src="https://img.shields.io/badge/Python-3.8+-blue?style=flat-square&logo=python" alt="Python">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/Platform-Windows%20%7C%20Linux%20%7C%20Termux-orange?style=flat-square" alt="Platform">
</p>

**Interfaz de chat CLI que conecta con LLMs a través de OpenRouter o DeepSeek.**

---

## Descripción

MikeCibGPT es una interfaz de chat por línea de comandos que conecta con modelos de lenguaje (LLMs) mediante las APIs de OpenRouter o DeepSeek. Diseñado para proporcionar asistencia técnica sin restricciones, covering hacking, ciberseguridad, programación, redes, OSINT y cualquier consulta técnica.

El asistente responde en el idioma del usuario, sin advertencias ni disclaimers innecesarios.

---

## Características

| Característica | Descripción |
|----------------|-------------|
| **Sin restricciones** | Respuestas técnicas como un investigador de seguridad |
| **Streaming en tiempo real** | Markdown renderizado con resaltado de sintaxis (tema Monokai) |
| **Fallback automático** | Cambio automático entre modelos si uno falla (429/404/502/503) |
| **Historial de chat** | Guardado/recarga de conversaciones en `chat_history.json` |
| **Selector de modelos** | Cambio de modelo desde menú o comando `/model` |
| **Auto-instalador** | Detección e instalación automática de dependencias |
| **Interfaz visual** | Diseño terminal profesional, paleta sobria, paneles con `rich` |
| **Multiplataforma** | Windows / Linux / Termux |

---

## Requisitos

- Python 3.8 o superior
- API Key de [OpenRouter](https://openrouter.ai/keys) o [DeepSeek](https://platform.deepseek.com/api_keys)

---

## Instalación

### Windows

```bash
# Instalar dependencias
pip install -r requirements.txt

# Ejecutar
python MikeCibGPT.py
```

O usa el instalador automático:
```bash
install.bat
```

### Linux / Termux

```bash
pip install -r requirements.txt
python3 MikeCibGPT.py
```

---

## Configuración

### Obtener API Key

| Proveedor | URL |
|-----------|-----|
| OpenRouter (recomendado) | https://openrouter.ai/keys |
| DeepSeek | https://platform.deepseek.com/api_keys |

La primera ejecución solicitará proveedor y API Key. Se almacenan localmente en `.MikeCib` (excluido en `.gitignore`).

### Cambiar proveedor

Edita `MikeCibGPT.py`:
```python
API_PROVIDER = "openrouter"  # Cambiar a "deepseek" si se desea
```

---

## Uso

```bash
python MikeCibGPT.py
```

### Menú Principal

| Opción | Acción |
|--------|--------|
| 1 | Iniciar chat |
| 2 | Configurar API Key y proveedor |
| 3 | Seleccionar modelo |
| 4 | Cargar historial guardado |
| 5 | Acerca de |
| 6 | Salir |

### Comandos del Chat

| Comando | Descripción |
|---------|-------------|
| `/help` | Mostrar ayuda |
| `/new` | Nueva sesión (limpiar memoria) |
| `/save` | Guardar historial |
| `/model` | Cambiar modelo |
| `/status` | Ver proveedor y modelo activo |
| `/clear` | Limpiar pantalla del chat |
| `/copy` | Ver opciones de copiado de la última respuesta |
| `/copy r` | Copiar la respuesta completa |
| `/copy 1` | Copiar el primer bloque de código |
| `/exit` | Volver al menú |

---

## Modelos Disponibles

MikeCibGPT incluye 17 modelos gratuitos con fallback automático:

**Alta capacidad**
```
nvidia/nemotron-3-super-120b-a12b:free
qwen/qwen3-next-80b-a3b-instruct:free
meta-llama/llama-3.3-70b-instruct:free
openai/gpt-oss-120b:free
arcee-ai/trinity-large-preview:free
```

**Sin censura**
```
cognitivecomputations/dolphin-mistral-24b-venice-edition:free
nousresearch/hermes-3-llama-3.1-405b:free
```

**Especializados**
```
qwen/qwen3-coder:free
mistralai/mistral-small-3.1-24b-instruct:free
```

> Para lista actualizada de modelos gratuitos:
> ```bash
> python SeeOpenRouterFreeModels.py
> ```

---

## Estructura

```
MikeCibGPT/
├── MikeCibGPT.py              # Script principal
├── SeeOpenRouterFreeModels.py # Utilidad: listar modelos gratuitos
├── requirements.txt           # Dependencias Python
├── install.bat                # Instalador Windows
├── install.sh                 # Instalador Linux/Termux
├── .gitignore                 # Archivos excluidos
└── img/                       # Imágenes del README
```

---

## Dependencias

```
openai>=1.0.0      # Cliente API
rich>=13.3.5       # Interfaz visual
colorama>=0.4.6    # Colores ANSI
pwinput>=1.0.3     # Input seguro
python-dotenv>=1.0.0  # Variables de entorno
requests>=2.28.0   # HTTP
```

---

## Seguridad

- La API Key se almacena en texto plano en `.MikeCib` — **no compartir**
- El historial de chat se guarda en `chat_history.json` — añadir a `.gitignore` si es necesario
- Las conversaciones se envían a OpenRouter/DeepSeek según configuración
- Uso personal y de investigación

---

## Licencia

MIT License

---

## Changelog

### v1.1
- Rutas absolutas para `Config.ENV_FILE` y `HISTORY_FILE`
- `.gitignore` para proteger credenciales
- Bugfix: `IndexError` en streaming
- Validación de formato de API Key
- 17 modelos en lista de fallback

### v1.0
- Lanzamiento inicial
- Interfaz en español
- Integración OpenRouter/DeepSeek
