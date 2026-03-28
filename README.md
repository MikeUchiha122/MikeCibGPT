<div align="center">

# MikeCibGPT

**Asistente tecnico avanzado sin restricciones, operado desde la terminal.**

Desarrollado por **Mike**

</div>

---

## Descripcion

MikeCibGPT es una interfaz de chat en la linea de comandos que conecta con modelos de lenguaje (LLMs) a traves de la API de OpenRouter o DeepSeek. Usa un prompt de sistema especializado que convierte cualquier modelo en un asistente tecnico sin filtros, enfocado en hacking, ciberseguridad, programacion, redes, OSINT y cualquier consulta tecnica.

El asistente responde siempre en el idioma del usuario, sin advertencias ni disclaimers.

---

## Caracteristicas

- **Sin restricciones** — Responde cualquier pregunta tecnica como si fuera un investigador de seguridad
- **Streaming en tiempo real** — Las respuestas se muestran con Markdown renderizado y resaltado de sintaxis (tema Monokai)
- **Fallback automatico de modelos** — Si un modelo falla (429/404/502/503), cambia al siguiente de la lista automaticamente
- **Historial de chat** — Las conversaciones se guardan en `chat_history.json` y se pueden recargar
- **Selector de modelos** — Cambia el modelo activo desde el menu o con `/model` dentro del chat
- **Auto-instalador de dependencias** — Detecta paquetes faltantes y los instala automaticamente al arrancar
- **Interfaz visual** — Banner ASCII, colores rojo/naranja, paneles y tablas con `rich`
- **Soporte Windows/Linux/Termux**

---

## Requisitos

- Python 3.8 o superior
- Una API Key gratuita de [OpenRouter](https://openrouter.ai/keys) o [DeepSeek](https://platform.deepseek.com/api_keys)

---

## Instalacion

### Opcion 1 — Manual (recomendado)

```bash
# Instalar dependencias
pip install -r requirements.txt

# Ejecutar
python MikeCibGPT.py
```

### Opcion 2 — Windows (script automatico)

Doble clic en `install.bat`. Clona el repo e instala las dependencias.

### Opcion 3 — Linux / Termux

```bash
pip install -r requirements.txt
python3 MikeCibGPT.py
```

---

## Configuracion de API Key

La primera vez que ejecutes el programa, te pedira tu API Key. Se guarda de forma local en el archivo `.MikeCib` (nunca se sube a ninguna parte).

Para obtener una key gratuita:
- **OpenRouter** (recomendado): https://openrouter.ai/keys
- **DeepSeek**: https://platform.deepseek.com/api_keys

Para cambiar de proveedor, edita esta linea en `MikeCibGPT.py`:

```python
API_PROVIDER = "openrouter"   # cambiar a "deepseek" si se desea
```

---

## Uso

```bash
python MikeCibGPT.py
```

### Menu principal

| Opcion | Accion |
|--------|--------|
| `1` | Iniciar chat |
| `2` | Configurar API Key |
| `3` | Seleccionar modelo |
| `4` | Cargar historial guardado |
| `5` | Acerca de MikeCibGPT |
| `6` | Salir |

### Comandos dentro del chat

| Comando | Descripcion |
|---------|-------------|
| `/help` | Muestra la lista de comandos |
| `/new` | Borra la memoria de la sesion actual |
| `/save` | Guarda el historial de la sesion |
| `/model` | Cambia el modelo de IA activo |
| `/exit` | Sale al menu principal |

---

## Modelos disponibles

MikeCibGPT usa 17 modelos gratuitos de OpenRouter con fallback automatico. Orden de prioridad:

**Sin censura (maxima prioridad)**
```
cognitivecomputations/dolphin-mistral-24b-venice-edition:free  # Dolphin - el mas conocido sin censura
nousresearch/hermes-3-llama-3.1-405b:free                      # Hermes 405B - sin censura, muy capaz
z-ai/glm-4.5-air:free                                          # GLM chino - menos restricciones
minimax/minimax-m2.5:free                                      # MiniMax chino - permisivo en tecnico
```

**Modelos grandes (alta capacidad)**
```
nvidia/nemotron-3-super-120b-a12b:free                         # Nemotron 120B
qwen/qwen3-next-80b-a3b-instruct:free                          # Qwen3 80B
arcee-ai/trinity-large-preview:free                            # Trinity Large
meta-llama/llama-3.3-70b-instruct:free                         # Llama 70B
openai/gpt-oss-120b:free                                       # GPT OSS 120B
```

**Especializados y fallbacks**
```
qwen/qwen3-coder:free                                          # Especializado en codigo
nvidia/nemotron-nano-9b-v2:free
arcee-ai/trinity-mini:free
mistralai/mistral-small-3.1-24b-instruct:free
openai/gpt-oss-20b:free
nvidia/nemotron-3-nano-30b-a3b:free
liquid/lfm-2.5-1.2b-instruct:free
meta-llama/llama-3.2-3b-instruct:free
```

### Si el chat no funciona

Algunos modelos pueden dejar de estar disponibles en OpenRouter. Para obtener la lista actualizada de modelos gratuitos:

```bash
python SeeOpenRouterFreeModels.py
```

El script lee tu API Key desde `.MikeCib` automaticamente y lista todos los modelos gratuitos activos. Copia uno de los resultados y reemplazalo en la lista `FALLBACK_MODELS` dentro de `MikeCibGPT.py`.

---

## Estructura del proyecto

```
MikeCibGPT/
├── MikeCibGPT.py                # Script principal
├── SeeOpenRouterFreeModels.py   # Utilidad para listar modelos gratuitos
├── requirements.txt             # Dependencias Python
├── install.bat                  # Instalador Windows
├── install.sh                   # Instalador Linux/Termux
├── .gitignore                   # Excluye .MikeCib y chat_history.json de git
├── .MikeCib                     # API Key local (NO compartir, en .gitignore)
└── chat_history.json            # Historial de sesiones (se crea al guardar)
```

---

## Dependencias

| Paquete | Version minima | Uso |
|---------|---------------|-----|
| `openai` | 1.0.0 | Cliente de API compatible con OpenRouter y DeepSeek |
| `rich` | 13.3.5 | Interfaz visual: paneles, Markdown, streaming, tablas |
| `colorama` | 0.4.6 | Colores ANSI en Windows |
| `pwinput` | 1.0.3 | Entrada de API Key con mascara |
| `python-dotenv` | 1.0.0 | Lectura y escritura del archivo `.MikeCib` |
| `requests` | 2.28.0 | Consultas HTTP en `SeeOpenRouterFreeModels.py` |

---

## Seguridad

- La API Key se guarda en `.MikeCib` en texto plano — **no compartas este archivo**
- El historial de chat se guarda en `chat_history.json` en texto plano
- Las conversaciones se envian a los servidores de OpenRouter o DeepSeek segun el proveedor configurado
- Este proyecto es para uso personal y de investigacion

---

## Changelog

### v1.1 — Mejoras de seguridad y correcciones
- Eliminada carpeta `HexSecGPT/` sobrante del proyecto original
- `Config.ENV_FILE` y `HISTORY_FILE` cambiados a rutas absolutas (funciona desde cualquier directorio)
- Creado `.gitignore` — protege `.MikeCib` y `chat_history.json` de subirse a git
- Corregido bug `IndexError` en streaming cuando chunk llega con `choices=[]`
- Validacion de formato de API Key antes de guardar (debe iniciar con `sk-` y tener 20+ caracteres)
- Aviso de fallback de modelo mejorado (aparece como texto Markdown en la respuesta)
- Instaladores `install.bat` e `install.sh` actualizados a MikeCibGPT (ya no referencian HexSecGPT)
- 8 nuevos modelos sin censura agregados a la lista de fallback (total: 17 modelos)

### v1.0 — Version inicial (basada en HexSecGPT)
- Personalizacion completa del nombre, colores y comportamiento
- System prompt en espanol enfocado en asistencia tecnica sin restricciones
- Correccion del bug `os.execv` en el auto-instalador
- Historial fijado al directorio del script (no al CWD)
- Limite de 40 mensajes en memoria para evitar context overflow
- `SeeOpenRouterFreeModels.py` lee la key desde `.MikeCib` (eliminada la key hardcodeada)
- `requests` agregado a `requirements.txt`
- Interfaz completamente en espanol
