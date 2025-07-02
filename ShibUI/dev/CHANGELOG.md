# ShibUI Changelog

## Versioning

### Semantic Versioning (SemVer) adapted for ESO Addon Development

**ShibUI** follows a custom versioning format to better align with the ESO addon ecosystem:

**Format:** `v[major].[minor].[esoapi]`

- **Major** – Traditional SemVer-style milestones reflecting significant changes, such as module-wide refactors or architecture updates. May introduce breaking changes or new dependencies.  
- **Minor** – Combines both new features and bug fixes. Patch-level updates are streamlined into this tier for simplicity.  
- **ESOAPI** – Indicates the ESO API version the addon is built for (e.g., `46` for Update 46).  
  A value of `0` denotes a **pre-release** or **internal development version** not yet targeted at a specific game update (e.g., `v0.3.0` is a dev build before targeting Update 46).

---

## Changelog

### v1.0.46
- **Init:** First public version of ShibUI.  
- **Refined:** Codebase with consistent formatting and improved UI control structure.  
- **Fixed:** Ultimate button scaling now resets correctly after bar swaps, preventing stacking or incorrect sizes.
- **Fixed:** Attribute bar now remains locked as intended.
- **Improved:** Localization of functions and globals.  
- **Reworked:** LAM2 integration for initial release, with new layout, subsections, and detailed descriptions.  
- **Documented:** Updated README and user instructions.

### v0.9.0
- **Added:** Setting for hiding ActionBar Keybind text.  
- **Added:** Setting for enlarged ultimate buttons.  
- **Added:** Setting for hiding target bars outside of combat.  
- **Fixed:** WeaponSwap toggle not working correctly.  
- **Fixed:** Debugging kept finding nils and printed useless messages.  
- **Fixed:** Debug message kept repeating after selecting a player bar width size.

### v0.8.0
- **Added:** LAM settings for width layouts: Normal (Locked), Default (Dynamic), and Expanded (Locked).  
- **Added:** LAM setting for Pyramid layout for attribute bars.  
- **Added:** Pyramid layout for player attribute bars.  
- **Changed:** Default attribute bar layout set to Shibui layout when PlayerBars is enabled.  
- **Improved:** `sui.Debug` to handle more info specifics (e.g., source, message, delay).

### v0.7.0
- **Added:** Slash commands `/sui` (reload UI) and `/shibui` (open settings).  
- **Added:** `suiMisc.lua` for miscellaneous textures.  
- **Moved:** `SUI.Debug` function to `suiDebug.lua`.

### v0.6.0
- **Added:** Debug function linked to each module.  
- **Added:** Toggle options in settings.  
- **Added:** `suiGroup.lua` for group and companion textures.  
- **Changed:** Updated key modules to use `RedirectTexture()` with a blank texture instead of `SetAlpha`.

### v0.5.0
- **Core refactor:** Scaled back to flat shared namespace.  
- **Added:** `SUI` global metatable and local reference for ShibUI.  
- **Added:** Centralized entry point for module initialization.  
- **Changed:** File structure and filenames updated to camelCase format.  
- **Removed:** `suiexperience` module.  
- **Merged:** `suicompass` and `suibossbar` into `suiCompass.lua`.

### v0.4.0
- **Core refactor:** Adopted shared global namespace with nested modules.  
- **Added:** `suiactionbar`, `suibossbar`, `suicompass`, `suiexperience`, `suiplayerbar`, and `suitargetbar` modules.

### v0.3.0
- **Added:** LAM2 (LibAddonMenu-2.0).

### v0.2.0
- **Fixed:** Keybinding issue where bindings were not registering properly.

### v0.1.0
- Initial private release of ShibUI.  
- Core addon structure with `/reloadui` support and optional confirmation prompt.
