# ShibUI Agent Documentation

## Project Summary

**ShibUI** is a minimalistic Elder Scrolls Online (ESO) addon that modernizes and cleans up the default user interface. The name derives from the Japanese aesthetic concept "shibui" (渋い), meaning subtle, refined elegance—simple yet sophisticated.

### Key Information
- **Version**: 1.8.0 (follows custom SemVer: MAJOR.MINOR.ESOAPI)
- **Author**: Shownie & AI
- **License**: MIT
- **ESO API**: 101047-101048 (Update 46-47)
- **Dependencies**: Optional LibAddonMenu-2.0 for settings UI

## Project Structure

```
ShibUI/
├── ShibUI.lua              # Main entry point and module initialization
├── ShibUI.txt              # Addon manifest file
├── core/                   # Core functionality modules
│   ├── debug.lua          # Debug logging system
│   ├── miscellaneous.lua  # Misc UI modifications
│   └── reloadui.lua       # UI reload functionality
├── settings/              # Configuration and saved variables
│   ├── savedvars.lua      # SavedVars management
│   └── settings.lua       # LibAddonMenu settings panel
├── hud/                   # HUD modification modules
│   ├── actionbar.lua      # Action bar modifications
│   ├── attributebar.lua   # Player attribute bars
│   ├── compass.lua        # Compass styling
│   ├── targetbar.lua      # Target frame modifications
│   ├── groupunitframe.lua # Group member frames
│   └── playerprogressbar.lua # XP/CP progress bar
└── xml/                   # UI template definitions
    ├── actionbar.xml      # Action bar templates
    ├── compass.xml        # Compass templates
    ├── groupunitframe.xml # Group frame templates
    ├── targetbar.xml      # Target frame templates
    ├── playerprogressbar.xml # Progress bar templates
    └── bindings.xml       # Keybinding definitions
```

## Architecture Patterns

### Module System
- **Global Namespace**: All modules use the shared `SUI` global table
- **Initialization Order**: Settings → Core → HUD modules
- **Module Pattern**: Each module is a table with an `Initialize()` method
- **Dependency Management**: SavedVars must initialize first, others are independent

### UI Modification Techniques
1. **Template Application**: Uses `ApplyTemplateToControl()` with custom XML templates
2. **Texture Hiding**: Sets `alpha="0"` or `hidden="true"` to remove visual elements
3. **SecurePostHook**: Hooks into game functions to apply modifications
4. **Event Handling**: Registers for ESO events to respond to game state changes

### Code Style Guidelines
- **Lua Conventions**: Uses camelCase for files, PascalCase for modules
- **Local References**: Creates local `sv` reference to SavedVars for performance
- **Logging Pattern**: Each module defines `local Log = function(...) SUI.Debug:Log("ModuleName", ...) end`
- **Error Handling**: Graceful degradation when dependencies are missing

## Key Features

### Current Modules
1. **Action Bar**: Removes textures, scales ultimate buttons, toggles keybindings/weapon swap
2. **Attribute Bar**: Pyramid/ShibUI layouts, width modes (normal/default/expanded)
3. **Target Bar**: Hostile-only filtering, combat-based visibility
4. **Compass**: Clean styling with template modifications
5. **Group Unit Frames**: Simplified group member display
6. **Player Progress Bar**: XP/CP tracking with toggle functionality

### Settings System
- **Account/Character Scope**: Configurable via LibAddonMenu
- **Live Updates**: Many settings apply immediately without reload
- **Default Values**: Comprehensive defaults in `savedvars.lua`
- **Validation**: Settings include tooltips and type checking

## Development Guidelines

### Adding New Modules
1. Create module file in appropriate directory (`core/`, `hud/`, `settings/`)
2. Follow the module pattern: `SUI.ModuleName = SUI.ModuleName or {}`
3. Implement `Initialize()` method
4. Add to initialization order in `SUI:InitializeModules()`
5. Create corresponding XML template if needed
6. Add settings section to `settings.lua` if configurable

### XML Template Guidelines
- Use `virtual="true"` for reusable templates
- Prefix template names with `SUI_`
- Use `alpha="0"` to hide textures while preserving functionality
- Use `hidden="true"` to completely remove elements
- Override dimensions for scaling modifications

### Code Quality Standards
- **Performance**: Use local references for frequently accessed globals
- **Readability**: Clear variable names, consistent indentation
- **Documentation**: Comment complex logic and UI modifications
- **Error Handling**: Check for nil values and missing dependencies
- **Debugging**: Use the centralized Debug system for troubleshooting

### Version Management
- **Format**: `MAJOR.MINOR.ESOAPI` (e.g., 1.8.0 for ESO API 101047)
- **ESOAPI = 0**: Indicates pre-release/development version
- **Breaking Changes**: Increment MAJOR for architecture changes
- **Features/Fixes**: Increment MINOR for new features and bug fixes

### Testing Approach
- **In-Game Testing**: Load addon in ESO test environment
- **Settings Validation**: Test all LAM settings for proper functionality
- **Event Handling**: Verify event registration and cleanup
- **Performance**: Monitor for frame rate impact and memory usage

## Color Palette (Shibui Theme)

The addon uses a muted, refined color palette inspired by Japanese aesthetics:

| Color | Hex | Usage |
|-------|-----|-------|
| Kaki (柿色) | `#E6A57E` | Soft persimmon orange—warm accents |
| Byakuroku (白緑) | `#B7D3B2` | Pale mint green—subtle highlights |
| Usuzumi (薄墨) | `#D4D4D4` | Light grey—neutral backgrounds |
| Tōryoku (淡緑) | `#C9D8C5` | Muted sage—depth without heaviness |
| Shirocha (白茶) | `#EDE6DB` | Off-white beige—background balance |

## Common Tasks

### Adding a New HUD Module
1. Create `hud/newmodule.lua` with module table and Initialize method
2. Create `xml/newmodule.xml` with UI templates if needed
3. Add module to `ShibUI.txt` file list
4. Add initialization call to `SUI:InitializeModules()`
5. Add settings section to `settings.lua` if configurable

### Modifying UI Elements
1. Identify the game control to modify
2. Create XML template with desired changes
3. Use `ApplyTemplateToControl()` in Lua module
4. Hook relevant game functions with `SecurePostHook`
5. Test thoroughly for side effects

### Adding Settings
1. Add default value to `SUI.SavedVars.defaults`
2. Create settings controls in appropriate section function
3. Implement getFunc/setFunc with SavedVars reference
4. Add live update logic if setting doesn't require reload

This documentation serves as a comprehensive guide for understanding, maintaining, and extending the ShibUI addon codebase.