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

### Known Issues
- The Action Bar ultimate button scaling may not reset correctly after bar swaps in some scenarios.

### v1.9.48
- **Added:** Chat Window Module.
- **Fixed:** `PlayerProgressBar` Now shows below original position to avoid overlapping when always visible.
- **Added:** `slashcommands` module to support spaces. `/sui command` now works and also includes a list of all commands.
- **Changed:** Slash commands for LAM settings to `/shibui`

### v1.8.48
- **Bumped:** AddOnVersion to 1848 for ESO Addon distribution.
- **Updated:** README.md to reflect recent changes and clarify settings.
- **Changed:** slash commands to use `/sui` prefix for consistency.
- **Added:** `/sui targetbarhostile` command to toggle Target Bar hostile-only filter.
- **Added:** `/sui progressbar` command to toggle Player Progress Bar visibility.
- **Added:** `/sui settings` command to open ShibUI settings panel (if LAM2 is installed).
- **Added:** `/sui reload` command to invoke reload helper (see settings for binding).

### v1.8.0
- **Moved:** Dev files to root. Not included in release packages.
- **Updated:** Codebase to match current state of ShibUI.
- **Improved:** Documentation and comments throughout the code.
- **General:** Code cleanup and optimization.
- **Added:** Keybinding to toggle Target Bar visibility.
- **Added:** Target Bar visibility toggle command `/tbh`.
- **Added:** Keybinding to toggle Player Progress Bar visibility.
- **Added:** Player Progress Bar visibility toggle command `/ppb`.
- **Fixed:** Target Bar to show/hide correctly based on settings and combat state.
- **Removed:** Styling conditions. All styling is now applied consistently.
- **Refactored:** Attribute Bar initialization to streamline loading and remove unused settings.
- **Fixed:** Attribute Bar Pyramid layout not applying correctly on load.

### v1.7.0
- **Reworked:** Debug:Log method for consistent debug message formatting.
- **Fixed:** Player Progress Bar to show on initialization if enabled in settings.

### v1.6.0
- **Refactored:** Initialization order across all modules to ensure proper loading sequence.
- **Added:** SavedVars handling to each module for better state management.
- **Improved:** Overall code structure and readability.
- **Fixed:** Player Progress module display issues.
- **Fixed:** Player Progress bar not updating correctly on level/champion point changes.

### v1.5.0
- **Refactored:** Code cleanup and optimization across all modules.
- **Fixed:** Action Bar ultimate button scaling issue after bar swaps.
- **Added:** playerprogress.xml file for Player Progress module.
- **Added:** Player Progress module to track and display player experience and champion points.
- **Moved:** SavedVariables to `ShibUI.lua` for better organization and accessibility.
- **Removed:** Debug messages from all modules until further notice.
- **Refactored:** parts to utilize colon syntax for methods where applicable.

### v1.4.0
- **Reworked:** Group Unit Frame module to use modified GuiXml templates with `ApplyTemplateControl()`.
- **Added:** groupunitframe.xml file for Group Unit Frame module.
- **Disabled:** LAM settings for Group Unit Frame module (settings will be reintroduced in a future update).

### v1.3.0
- **Reworked:** Compass and Bossbar modules to use modified GuiXml templates with `ApplyTemplateControl()`.
- **Added:** compass.xml file for Compass module.
- **Disabled:** LAM settings for Compass and Bossbar modules (settings will be reintroduced in a future update).
- **Disabled:** LAM settings for Action Bar module (settings will be reintroduced in a future update).

### v1.2.0
- **Refactored:** Partial code cleanup and optimization. Now a semi OOP-style structure with module tables and methods.
- **Reworked:** Action Bar module to use modified GuiXml templates with `ApplyTemplateControl()`.
- **Added:** actionbar.xml file for Action Bar module.
- **Fixed:** Ultimate button scaling issue after bar swaps.
- **Removed:** Debug messages from the Action Bar module.
- **Removed:** Action Bar settings. Only complete removal of the module is possible now.
- **Added:** Buff/Debuff icon support to Action Bar module and XML layout.

### v1.1.47
- **Added:** Minor delay on targetbar visibility at end of combat.
- **Changed:** Ultimatebutton scaling behavior, but still fails on barswap.
- **Added:** Tooltip info about Ultimatebutton misbehaviour.

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
