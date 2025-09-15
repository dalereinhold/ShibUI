--------------------------------------------------
-- ShibUI Settings Module
--------------------------------------------------

local sui = ShibUI

--------------------------------------------------
-- ShibUI default settings
--------------------------------------------------
sui.defaults = {
    accountWide = true,
    confirmReload = true,
    debug = false,
    
    -- Attribute Bar
    attributeBar = true,
    attributeBarPyramid = false,
    attributeBarSize = "default",

    -- Action Bar
    enableActionBar = true,
    actionBar = true,
    weaponSwapVisible = false,
    keybindsVisible = false,
    ultimateButtonScaled = true,

    -- Target Bar
    targetBar = true,
    hideTargetBar = true,

    -- Compass and Boss Bar
    compass = true,

    -- Unit Frame
    unitFrame = true,
}

--------------------------------------------------
-- Settings Section Helpers
--------------------------------------------------
local function GeneralSettings()
    return {
        {
            type = "description",
            text = "ShibUI is a minimal and modern interface mod for ESO, created by Shownie in collaboration with AI. It hides or replaces textures to achieve a clean, unobtrusive style.\n\nThe name 'ShibUI' comes from the Japanese word 'shibui' (渋い), which describes a subtle, refined aesthetic — simple, yet elegant.",
            width = "full",
        },
        {
            type = "checkbox",
            name = "Account Wide Settings",
            tooltip = "Use the same settings for all characters on this account.",
            getFunc = function() return sui.accountSaved.accountWide end,
            setFunc = function(value) sui.accountSaved.accountWide = value end,
            default = sui.defaults.accountWide,
            requiresReload = true,
            width = "full",
        },
        {
            type = "checkbox",
            name = "Confirm Reload UI",
            tooltip = "Show a confirmation prompt before reloading the UI.",
            getFunc = function() return sui.saved.confirmReload end,
            setFunc = function(value) sui.saved.confirmReload = value end,
            default = sui.defaults.confirmReload,
        },
        {
            type = "checkbox",
            name = "Enable Debug Mode",
            tooltip = "Show additional debug messages in chat.",
            getFunc = function() return sui.saved.debug end,
            setFunc = function(value) sui.saved.debug = value end,
            default = sui.defaults.debug,
        },
    }
end

local function AttributeBarSettings()
    return {
        { type = "header", name = "Attribute Bar" },
        {
            type = "checkbox",
            name = "Enable Attribute Bar",
            tooltip = "Removes textures and applies a modern style to the attribute bar.",
            getFunc = function() return sui.saved.AttributeBar end,
            setFunc = function(value)
                sui.saved.AttributeBar = value
                sui.initializeAttributeBar()
            end,
            default = sui.defaults.AttributeBar,
            requiresReload = false,
        },
        {
            type = "checkbox",
            name = "Pyramid Layout",
            tooltip = "Stack attribute bars in a pyramid style (Health on top of Magicka and Stamina).",
            getFunc = function() return sui.saved.attributeBarPyramid end,
            setFunc = function(value)
                sui.saved.attributeBarPyramid = value
                local layout = value and "pyramid" or "shibui"
                sui.applyAttributeBarLayout(layout)
            end,
            default = sui.defaults.attributeBarPyramid,
        },
        {
            type = "dropdown",
            name = "Attribute Bar Width Mode",
            tooltip = "Choose Normal or Expanded for fixed width, or Default for dynamic width based on current stats.",
            choices = { "Normal", "Default", "Expanded" },
            choicesValues = { "normal", "default", "expanded" },
            getFunc = function() return sui.saved.attributeBarSize end,
            setFunc = function(mode)
                sui.saved.attributeBarSize = mode
                sui.applyAttributeBarSize(mode)
            end,
            default = sui.defaults.attributeBarSize,
        },
    }
end

local function ActionBarSettings()
    return {
        { type = "header", name = "Action Bar" },
        {
            type = "checkbox",
            name = "Enable Action Bar",
            tooltip = "Renmoves textures and applies a modern style to the action bar.",
            getFunc = function() return sui.saved.enableActionBar end,
            setFunc = function(value)
                sui.saved.enableActionBar = value
                ShibUI.ActionBar:Initialize()
            end,
            default = sui.defaults.enableActionBar,
            requiresReload = false,
        },
        --[[{
            type = "checkbox",
            name = "Show Weapon Swap",
            tooltip = "Toggle the visibility of the weapon swap icon.",
            getFunc = function() return sui.saved.weaponSwapVisible end,
            setFunc = function(value)
                sui.saved.weaponSwapVisible = value
                sui.applyActionBarSettings()
            end,
            default = sui.defaults.weaponSwapVisible,
        },
        {
            type = "checkbox",
            name = "Show Keybinds",
            tooltip = "Toggle the visibility of keybind labels on the action bar.",
            getFunc = function() return sui.saved.keybindsVisible end,
            setFunc = function(value)
                sui.saved.keybindsVisible = value
                sui.applyActionBarSettings()
            end,
            default = sui.defaults.keybindsVisible,
        },
        {
            type = "checkbox",
            name = "Scale Ultimate Buttons",
            tooltip = "Toggle between normal and larger size for ultimate buttons. Fails to apply correctly in some situations.",
            getFunc = function() return sui.saved.ultimateButtonScaled end,
            setFunc = function(value)
                sui.saved.ultimateButtonScaled = value
                sui.applyActionBarSettings()
            end,
            default = sui.defaults.ultimateButtonScaled,
        },]]--
    }
end

local function TargetBarSettings()
    return {
        { type = "header", name = "Target Bar" },
        {
            type = "checkbox",
            name = "Enable Target Bar",
            tooltip = "Removes textures and applies a modern style to the target bar.",
            getFunc = function() return sui.saved.targetBar end,
            setFunc = function(value)
                sui.saved.targetBar = value
                sui.initializeTargetBar()
            end,
            default = sui.defaults.targetBar,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "Hide Target Bar Out of Combat",
            tooltip = "Toggle the visibility of the target bar when not in combat.",
            getFunc = function() return sui.saved.hideTargetBar end,
            setFunc = function(value)
                sui.saved.hideTargetBar = value
                sui.initializeTargetBar()
            end,
            default = sui.defaults.hideTargetBar,
        },
    }
end

local function CompassSettings()
    return {
        { type = "header", name = "Compass and Boss Bar" },
        {
            type = "checkbox",
            name = "Enable Compass and Boss Bar",
            tooltip = "Removes textures and applies a modern style to the compass and boss bar.",
            getFunc = function() return sui.saved.compass end,
            setFunc = function(value)
                sui.saved.compass = value
                sui.initializeCompass()
            end,
            default = sui.defaults.compass,
            requiresReload = true,
        },
    }
end

local function UnitFrameSettings()
    return {
        { type = "header", name = "Unit Frame" },
        {
            type = "checkbox",
            name = "Enable Unit Frame",
            tooltip = "Removes textures and applies a modern style to the unit frame.",
            getFunc = function() return sui.saved.unitFrame end,
            setFunc = function(value)
                sui.saved.unitFrame = value
                sui.initializeUnitFrame() 
            end,
            default = sui.defaults.unitFrame,
            requiresReload = true,
        },
    }
end

--------------------------------------------------
-- Settings Panel Creation
--------------------------------------------------
local function SettingsPanel()
    local LAM = LibAddonMenu2
    if not LAM then
        sui.debug("Settings", "LibAddonMenu2 not found. Settings panel will not be created.")
        return
    end

    local panelData = {
        type = "panel",
        name = sui.menuName,
        displayName = sui.displayName,
        author = sui.author,
        version = sui.version,
        slashCommand = "/shibui",
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local optionsTable = {}
    local function appendOptions(tbl)
        for _, v in ipairs(tbl) do
            table.insert(optionsTable, v)
        end
    end

    appendOptions(GeneralSettings())
    appendOptions(AttributeBarSettings())
    appendOptions(ActionBarSettings())
    appendOptions(TargetBarSettings())
    appendOptions(CompassSettings())
    appendOptions(UnitFrameSettings())

    LAM:RegisterAddonPanel(sui.menuName, panelData)
    LAM:RegisterOptionControls(sui.menuName, optionsTable)
end

--------------------------------------------------
-- Settings Initialization
--------------------------------------------------
function sui.initializeSettings()
    sui.accountSaved = ZO_SavedVars:NewAccountWide("suiSavedVars", 1, nil, sui.defaults)
    sui.characterSaved = ZO_SavedVars:New("suiSavedVars", 1, nil, sui.defaults)

    local accountWide = sui.accountSaved.accountWide or false
    sui.saved = accountWide and sui.accountSaved or sui.characterSaved

    sui.debug("Settings", "Loaded settings: accountWide = " .. tostring(accountWide))

    SettingsPanel()
end
