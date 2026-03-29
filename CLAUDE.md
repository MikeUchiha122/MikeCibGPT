# CLAUDE.md — MikeCibGPT

AI assistant reference for working with this codebase.

---

## Project Overview

**MikeCibGPT** is a Python CLI chat interface for interacting with LLMs via the OpenRouter and DeepSeek APIs. It features streaming responses, a Matrix-style Rich terminal UI, automatic model fallback across 17 free models, and persistent chat history.

- **Language:** Python 3.8+
- **Version:** v1.2
- **License:** MIT
- **Platforms:** Windows, Linux, Termux (Android)

---

## Repository Structure

```
MikeCibGPT/
├── MikeCibGPT.py                # Main application (~972 lines) — all logic lives here
├── SeeOpenRouterFreeModels.py   # Standalone utility to list free OpenRouter models
├── requirements.txt             # Python dependencies
├── install.bat                  # Windows installer (pip + dependency setup)
├── install.sh                   # Linux/Termux installer
├── README.md                    # User documentation (Spanish)
└── img/
    ├── home.png                 # App screenshot
    └── provider-model-example.jpg
```

---

## Architecture

All production code is in `MikeCibGPT.py`. It is organized into five classes:

### `Config`
Constants and configuration. Edit this class to change:
- API providers (`PROVIDERS` dict) — base URLs for OpenRouter and DeepSeek
- Model list (`MODELS` list) — 17 free fallback models across APEX/CORE/SWIFT tiers
- `MAX_HISTORY` (40) — max chat messages kept in context
- `TIMEOUT` (60s) — API request timeout
- `ENV_FILE` (`.MikeCib`) — credentials storage path
- `HISTORY_FILE` (`chat_history.json`) — session persistence path
- Color scheme (`COLORS` dict) — Matrix-style green palette

### `UI`
All terminal rendering. Key methods:
- `banner()` — ASCII art logo, adapts to terminal width
- `main_menu()` / `model_menu()` / `history_menu()` — navigation screens
- `print_user_msg(msg)` — styled user message with timestamp
- `stream_response(generator, model_name)` — two-phase render: live streaming cursor → final Markdown
- `copy_menu(response)` — clipboard copy (full response or extracted code blocks)
- `get_input(prompt)` — user input with prompt styling

The UI detects terminal width (`shutil.get_terminal_size()`) and adjusts layout responsively (minimum 60 chars).

### `MikeCibBrain`
Core AI logic. Key methods:
- `chat(user_message)` → generator that yields response chunks
- `_try_model(model, messages)` → single model attempt, raises on 429/404/502/503
- Fallback loop: tries primary model first, then iterates through remaining 16 models
- Manages `self.history` (list of `{"role": ..., "content": ...}` dicts)
- Prunes history when it exceeds `MAX_HISTORY`

Configuration sent to API:
```python
temperature=1.0
stream=True
extra_body={"safe_mode": False, "route": "fallback"}
```

### `HistoryManager`
JSON persistence for chat sessions. Methods:
- `save_session(history, model)` — appends a timestamped session to `chat_history.json`
- `load_sessions()` → list of past sessions
- `get_session(index)` → retrieve a specific session's messages

### `App`
Entry point and navigation loop. Methods:
- `setup()` — checks/prompts for API key, verifies connection
- `run()` — main menu loop
- `run_chat()` — chat loop with command processing
- Handles in-chat commands: `/help`, `/new`, `/save`, `/model`, `/copy`, `/exit`

---

## Data Flow

```
User types message
  → App.run_chat()
    → UI.get_input()
    → MikeCibBrain.chat()  [generator]
      → Try primary model (OpenAI SDK streaming)
      → On error (429/404/5xx): try next fallback model
      → Yield text chunks
    → UI.stream_response()  [two-phase: live → markdown]
    → HistoryManager.save_session()  [if /save issued]
    → UI.copy_menu()  [optional]
```

---

## Dependencies

```
openai>=1.0.0       # Used as API client for both OpenRouter and DeepSeek
rich>=13.3.5        # Terminal UI: Markdown, tables, panels, Live updates
colorama>=0.4.6     # ANSI color support (Windows compatibility)
pwinput>=1.0.3      # Masked API key input
python-dotenv>=1.0.0 # Load/save .MikeCib credential file
requests>=2.28.0    # HTTP (model list verification)
```

`pyperclip` is used for clipboard support but is not in `requirements.txt` — it is auto-installed at runtime via `check_dependencies()`.

### Auto-install mechanism
`check_dependencies()` (called at startup) uses `__import__()` to test each dependency, runs `pip install` for any missing packages, then restarts the process via `os.execv()`.

---

## Credentials & Configuration

| File | Purpose | Git-tracked |
|------|---------|------------|
| `.MikeCib` | API key storage (`MikeCibGPT-API=sk-...`) | No (.gitignore) |
| `chat_history.json` | Saved chat sessions | No (.gitignore) |

API key is read/written with `python-dotenv`. On first run, user is prompted with a masked input and the key is saved to `.MikeCib`.

---

## Development Conventions

### Code Style
- Standard Python (no enforced formatter like Black or Ruff — be consistent with existing style)
- Classes use `PascalCase`, methods use `snake_case`
- Constants defined as class attributes on `Config`
- No type annotations in existing code — do not add them unless asked

### No Test Framework
There are no automated tests. Manual verification is done by running the app:
```bash
python3 MikeCibGPT.py
```

### Adding a New Model
1. Add the model string to `Config.MODELS` list in `MikeCibGPT.py`
2. The fallback loop in `MikeCibBrain.chat()` will automatically include it
3. Update the tier comment (APEX/CORE/SWIFT) for organizational clarity

### Adding a New Provider
1. Add an entry to `Config.PROVIDERS` dict with `base_url` and `model` keys
2. Update `App.setup()` and the API config menu in `App.run()` to expose the new provider
3. The `openai.OpenAI(base_url=..., api_key=...)` client pattern handles any OpenAI-compatible endpoint

### Streaming Pattern
Response streaming uses Rich's `Live` context manager:
```python
with Live(..., transient=True) as live:
    for chunk in generator:
        live.update(render_function(accumulated_text))
# After Live exits, print final Markdown-rendered version
```
The `\x00UI\x00` prefix convention is used to pass UI-only messages through the generator without adding them to chat history.

### Special Marker: `\x00UI\x00`
Chunks yielded from `MikeCibBrain.chat()` prefixed with `\x00UI\x00` are status/info messages (e.g., "Trying fallback model...") shown in the UI but never stored in `self.history`. Strip or skip this prefix when processing generator output.

---

## Running the Application

```bash
# Install dependencies
pip install -r requirements.txt

# Run
python3 MikeCibGPT.py   # Linux/Mac
python MikeCibGPT.py    # Windows

# List available free OpenRouter models
python3 SeeOpenRouterFreeModels.py
```

### First-Run Setup
1. App checks for `.MikeCib` — if missing, prompts for API key
2. Validates key with a test call to OpenRouter `/models`
3. Proceeds to main menu on success

---

## Git Workflow

- **Active development branch:** `claude/add-claude-documentation-tCITn`
- **Main branch:** `main`
- Commit messages follow conventional style: `type: description` (e.g., `docs: ...`, `feat: ...`, `fix: ...`)

---

## Key Files Quick Reference

| File | What to edit for... |
|------|-------------------|
| `MikeCibGPT.py` → `Config.MODELS` | Adding/removing LLM models |
| `MikeCibGPT.py` → `Config.PROVIDERS` | Adding API providers |
| `MikeCibGPT.py` → `Config.MAX_HISTORY` | Changing context window size |
| `MikeCibGPT.py` → `MikeCibBrain.__init__` | Modifying system prompt |
| `MikeCibGPT.py` → `UI.banner()` | Changing the ASCII logo |
| `MikeCibGPT.py` → `App.run_chat()` | Adding new `/commands` |
| `requirements.txt` | Adding Python dependencies |
