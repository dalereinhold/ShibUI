# ShibUI Addon – Codebase Documentation

**ShibUI** is a minimalistic Elder Scrolls Online (ESO) addon that modernizes and cleans up the user interface. This documentation covers the structure, modules, and main logic of the codebase, excluding the developer and style guide markdown files.

---

## 📁 Directory Structure

```
ShibUI/
├── ShibUI.lua           # Main entry point
├── ShibUI.txt           # Addon manifest
├── core/
│   ├── debug.lua
│   ├── miscellaneous.lua
│   └── reloadui.lua
├── dev/
│   ├── CHANGELOG.md
│   ├── CODEBASE.md
│   └── README.md
├── settings/
│   └── settings.lua
├── ui/
│   ├── actionbar.lua
│   ├── attributebar.lua
│   ├── compass.lua
│   ├── targetbar.lua
│   └── unitframe.lua
└── xml/
    └── bindings.xml
```

---

## 🗂️ File-by-File Overview

### 1. `ShibUI.lua`
- **Purpose:** Main entry point; sets up global metadata, initializes all modules, and registers the addon load event.
- **Key Logic:**
  - Declares the global `ShibUI` table and local alias `sui`.
  - Stores metadata (name, version, author, etc.).
  - Defines `sui.initialize()` which calls all module initializers in order.
  - Registers for the `EVENT_ADD_ON_LOADED` event to trigger initialization.
  - Handles attribute bar width and action bar keybinds on relevant events.

---

### 2. `ShibUI.txt`
- **Purpose:** ESO manifest file.
- **Contents:** Metadata, file load order, dependencies (LibAddonMenu-2.0), and saved variable declaration.

---

### 3. `core/debug.lua`
- **Purpose:** Debugging utilities.
- **Key Logic:**
  - `sui.debug(source, message, delay)`: Prints formatted debug messages to chat, with color coding and optional delay.
  - Only outputs if debug mode is enabled in settings.

---

### 4. `core/miscellaneous.lua`
- **Purpose:** Redirects miscellaneous UI textures to blank textures for a cleaner look.
- **Key Logic:**  
  - `sui.initializeMiscellaneous()`: Redirects several progress bar and meter textures to a blank DDS.

---

### 5. `core/reloadui.lua`
- **Purpose:** Implements reload UI logic and keybind dialog.
- **Key Logic:**
  - Registers a custom confirmation dialog for reloading the UI.
  - `sui.performReload()`: Shows confirmation or reloads UI directly based on settings.
  - `ReloadUI_OnKeybind()`: Public function for keybinds.
  - `sui.initializeReloadUI()`: Registers dialog, string IDs, and slash command `/sui`.

---

### 6. `settings/settings.lua`
- **Purpose:** Manages default and saved settings, and builds the settings panel using LibAddonMenu2.
- **Key Logic:**
  - Defines `sui.defaults` (default settings).
  - `sui.initializeSettings()`: Loads account-wide or character-specific settings using `ZO_SavedVars`.
  - Builds settings panel with sections for each UI module (attribute bar, action bar, target bar, compass, unit frame).
  - Each setting is linked to the corresponding logic in the UI modules.

---

### 7. `ui/actionbar.lua`
- **Purpose:** Controls the action bar's appearance and settings.
- **Key Logic:**
  - Redirects action bar textures to blank or default.
  - Controls weapon swap icon, keybind label visibility, and ultimate button scaling.
  - `sui.applyActionBarSettings()`: Applies all action bar settings.
  - `sui.initializeActionBar()`: Applies textures and settings on load.

---

### 8. `ui/attributebar.lua`
- **Purpose:** Manages attribute bar textures, width, and layout.
- **Key Logic:**
  - Redirects attribute bar textures.
  - Controls bar width (normal, default, expanded) and layout (pyramid, shibui, default).
  - `sui.applyAttributeBarSize(mode)`: Locks/unlocks bar width.
  - `sui.applyAttributeBarLayout(layout)`: Sets bar anchors/layout.
  - `sui.initializeAttributeBar()`: Applies textures and layout on load.

---

### 9. `ui/compass.lua`
- **Purpose:** Redirects compass and boss bar textures.
- **Key Logic:**
  - `sui.initializeCompass()`: Applies blank or default textures based on settings.

---

### 10. `ui/targetbar.lua`
- **Purpose:** Controls target bar appearance and visibility.
- **Key Logic:**
  - Redirects target bar textures.
  - `sui.targetBarVisibility()`: Shows/hides the target bar based on combat state, target health, and settings.
  - Registers for combat and target change events.
  - `sui.initializeTargetBar()`: Applies textures and sets up visibility logic.

---

### 11. `ui/unitframe.lua`
- **Purpose:** Redirects group and target unit frame textures.
- **Key Logic:**
  - `sui.initializeUnitFrame()`: Applies blank or default textures based on settings.

---

### 12. `xml/bindings.xml`
- **Purpose:** Defines keybinding for reloading the UI.
- **Key Logic:**  
  - Binds the `RELOAD_UI_KEYBIND` action to call `ReloadUI_OnKeybind()`.

---

### 13. `dev/CHANGELOG.md`
- **Purpose:** Changelog and versioning notes.

---

### 14. `dev/README.md`
- **Purpose:** User-facing readme, installation instructions, credits, and license.

---

## 🧩 Core Patterns and Conventions

- **Global Namespace:**  
  All modules use the global `ShibUI` table, with `local sui = ShibUI` for local access.

- **Initialization:**  
  Each module exposes an `initialize...` function, called in order from `sui.initialize()` in `ShibUI.lua`.

- **Settings:**  
  Defaults and saved variables are managed in `settings/settings.lua` using ESO's `ZO_SavedVars`.  
  The settings panel is built with LibAddonMenu2.

- **Texture Redirection:**  
  Most UI modules use `RedirectTexture` to swap default ESO textures for blank ones, achieving a clean look.

- **Debugging:**  
  Debug output is standardized and can be toggled via settings.

- **Event Handling:**  
  Uses ESO's `EVENT_MANAGER` for registering and unregistering event handlers in a consistent pattern.

---

## 📝 How to Extend or Modify

- **Add new UI features:**  
  Create a new file in `ui/`, add an `initialize...` function, and register it in the `initializers` list in `ShibUI.lua`.

- **Add settings:**  
  Extend the defaults and settings panel in `settings/settings.lua`, and link to your module logic.

- **Debugging:**  
  Use `sui.debug("ModuleName", "Message")` for consistent debug output.

---

## 📚 References

- `ShibUI.lua` — Main entry point and initialization logic.
- `settings/settings.lua` — Settings and saved variable management.
- `core/debug.lua` — Debugging utilities.
- `dev/README.md` — User documentation and license.
- `dev/CHANGELOG.md` — Changelog and versioning.

---

For further details, see the in-code comments and the user documentation in `dev/README.md`.