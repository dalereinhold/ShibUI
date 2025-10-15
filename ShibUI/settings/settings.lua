--------------------------------------------------
-- ShibUI Settings Module
--------------------------------------------------
local SUI = SUI
local sv

SUI.Settings = SUI.Settings or {}
local Settings = SUI.Settings

local Log = function(...) SUI.Debug:Log("Settings", ...) end

--------------------------------------------------
-- Settings Section Helpers
-- Each function returns a table of settings for a specific section.
-- These are combined to form the full settings panel.
-- Add new sections as needed.
-- Primary color rgba(255, 108, 55, 1) = "|cFF6C37|r"
-- Secondary color rgba(114, 141, 114, 1) = "|c728D72|r"   
-- Tertiary color rgba(238, 238, 238, 1) = "|cEEEEEE|r"   
--------------------------------------------------

local orange = "|cFF6C37"
local green  = "|c728D72"
local grey    = "|cEEEEEE"
local reset  = "|r"

local function GeneralSettings()
    return {
        {
            type = "description",
            text = grey .. "ShibUI is a minimal and modern interface mod for ESO, created by Shownie in collaboration with AI. It hides or replaces textures to achieve a clean, unobtrusive style.\n\nThe name 'ShibUI' comes from the Japanese word 'shibui' (渋い), which describes a subtle, refined aesthetic — simple, yet elegant." .. reset,
            width = "full",
        },
        { 
            type = "header",
            name = orange .. "General Settings " .. reset },
        { 
            type = "description", 
            text = grey .. "General settings for ShibUI." .. reset, 
            width = "full" },
        {
            type = "checkbox",
            name = green .. "Account Wide Settings" .. reset,
            tooltip = grey .. "Use the same settings for all characters on this account." .. reset,
            getFunc = function() return sv.accountWide end,
            setFunc = function(value) sv.accountWide = value end,
            default = SUI.SavedVars.defaults.accountWide,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = green .. "Confirm Reload UI" .. reset,
            tooltip = grey .. "Show a confirmation prompt before reloading the UI." .. reset,
            getFunc = function() return sv.confirmReload end,
            setFunc = function(value) sv.confirmReload = value end,
            default = SUI.SavedVars.defaults.confirmReload,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = green .. "Enable Debug Mode" .. reset,
            tooltip = grey .. "Toggle debug messages for troubleshooting. Requires UI reload to take effect." .. reset,
            getFunc = function() return sv.debug end,
            setFunc = function(value) sv.debug = value end,
            default = SUI.SavedVars.defaults.debug,
            requiresReload = true,
        },
    }
end

local function AttributeBarSettings()
    return {
        {
            type = "submenu",
            name = orange .. "Attribute Bar Layout Preview" .. reset,
            controls = {
                {
                    type = "description",
                    text = grey .. "Adjust the appearance and behavior of the attribute bar." .. reset,
                    width = "full"
                },
                {
                    type = "checkbox",
                    name = green .. "Enable Attribute Bar" .. reset,
                    tooltip = grey .. "Removes textures and applies a modern style to the attribute bar." .. reset,
                    getFunc = function() return sv.attributeBar end,
                    setFunc = function(value)
                        sv.attributeBar = value
                        SUI.InitializeAttributeBar()
                    end,
                    default = SUI.SavedVars.defaults.attributeBar,
                    requiresReload = true,
                },
                {
                    type = "checkbox",
                    name = green .. "Pyramid Layout" .. reset,
                    tooltip = grey .. "Stack attribute bars in a pyramid style (Health on top of Magicka and Stamina)." .. reset,
                    getFunc = function() return sv.attributeBarPyramid end,
                    setFunc = function(value)
                        sv.attributeBarPyramid = value
                        local layout = value and "pyramid" or "shibui"
                        SUI.ApplyAttributeBarLayout(layout)
                    end,
                    default = SUI.SavedVars.defaults.attributeBarPyramid,
                },
                {
                    type = "dropdown",
                    name = green .. "Attribute Bar Width Mode" .. reset,
                    tooltip = grey .. "Choose Normal or Expanded for fixed width, or Default for dynamic width based on current stats." .. reset,
                    choices = { "Normal", "Default", "Expanded" },
                    choicesValues = { "normal", "default", "expanded" },
                    getFunc = function() return sv.attributeBarSize end,
                    setFunc = function(mode)
                        sv.attributeBarSize = mode
                        SUI.ApplyAttributeBarSize(mode)
                    end,
                    default = SUI.SavedVars.defaults.attributeBarSize,
                },
                {
                    type = "dropdown",
                    name = green .. "Attribute Bar Layout" .. reset,
                    tooltip = grey .. "Default layout matches the game's default. Pyramid stacks Health on top of Magicka and Stamina. ShibUI stacks and widens attributes horizontally." .. reset,
                    choices = { "Default", "Pyramid", "ShibUI" },
                    choicesValues = { "default", "pyramid", "shibui" },
                    getFunc = function() return sv.attributeBarLayout or "default" end,
                    setFunc = function(value)
                        sv.attributeBarLayout = value
                        SUI.ApplyAttributeBarLayout(value)
                    end,
                    default = SUI.SavedVars.defaults.attributeBarLayout or "default",
                },
            }
        }
    }
end

local function ActionBarSettings()
    return {
        { 
            type = "submenu",
            name = orange .. "Action Bar" .. reset,
            controls = {
                {
                    type = "description",
                    text = grey .. "Adjust the appearance and behavior of the action bar and related elements." .. reset,
                    width = "full"
                },
                { 
                    type = "checkbox",
                    name = green .. "Enable Action Bar Styling" .. reset,
                    tooltip = grey .. "Apply a modern style to the action bar and related elements." .. reset,
                    getFunc = function() return sv.actionBar end,
                    setFunc = function(value) sv.actionBar = value end,
                    default = SUI.SavedVars.defaults.actionBar,
                    requiresReload = true,
                },
                {
                    type = "checkbox",
                    name = green .. "Hide Weapon Swap Icon" .. reset,
                    tooltip = grey .. "Toggle the visibility of the weapon swap icon on the action bar." .. reset,
                    getFunc = function() return true end,
                    setFunc = function(value) end,
                },
                {
                    type = "checkbox",
                    name = green .. "Hide Keybindings" .. reset,
                    tooltip = grey .. "Toggle the visibility of keybindings on the action bar." .. reset,
                    getFunc = function() return true end,
                    setFunc = function(value) end,
                },
                {
                    type = "checkbox",
                    name = green .. "Use Scaled Ultimate Slots" .. reset,
                    tooltip = grey .. "Toggle the use of scaled ultimate slots on the action bar." .. reset,
                    getFunc = function() return true end,
                    setFunc = function(value) end,
                },
                {
                    type = "slider",
                    name = green .. "Adjust Horizontal Action Bar Position" .. reset,
                    tooltip = grey .. "Fine-tune the horizontal position of the action bar." .. reset,
                    min = -100,
                    max = 100,
                    step = 1,
                    getFunc = function() return 1 or 50 end,
                    setFunc = function(value) end,
                },
                {
                    type = "checkbox",
                    name = green .. "Backbar Numeric countdown" .. reset,
                    tooltip = grey .. "Show numeric countdown on backbar abilities." .. reset,
                    getFunc = function() return true end,
                    setFunc = function(value) end,
                },
            }
        }
    }
end

local function TargetBarSettings()
    return {
        {
            type = "submenu",
            name = orange .. "Target Bar" .. reset,
            controls = {
                { 
                    type = "description", 
                    text = grey .. "Adjust the appearance and behavior of the target bar." .. reset, 
                    width = "full" },
                {
                    type = "checkbox",
                    name = green .. "Enable Target Bar Styling" .. reset,
                    tooltip = grey .. "Apply a modern style to the target bar." .. reset,
                    getFunc = function() return sv.targetBar end,
                    setFunc = function(value) sv.targetBar = value end,
                    default = SUI.SavedVars.defaults.targetBar,
                    requiresReload = true,
                },
                {
                    type = "checkbox",
                    name = green .. "Hide Target Bar Out of Combat" .. reset,
                    tooltip = grey .. "Toggle the visibility of the target bar when not in combat." .. reset,
                    getFunc = function() return sv.hideTargetBar end,
                    setFunc = function(value) sv.hideTargetBar = value end,
                    default = SUI.SavedVars.defaults.hideTargetBar,
                    requiresReload = true,
                },
            }
        }
    }
end

local function CompassSettings()
    return {
        {
            type = "submenu",
            name = orange .. "Compass and Boss Bar" .. reset,
            controls = {
                { 
                    type = "description", 
                    text = grey .. "Adjust the appearance of the compass and boss bar." .. reset, 
                    width = "full" 
                },
                {
                    type = "checkbox",
                    name = green .. "Enable Compass and Boss Bar Styling" .. reset,
                    tooltip = grey .. "Apply a modern style to the compass and boss bar." .. reset,
                    getFunc = function() return true end,
                    setFunc = function(value) end,
                },
                {
                    type = "slider",
                    name = green .. "Adjust Compass/Boss Bar Width" .. reset,
                    tooltip = grey .. "Set the width of the compass and boss bar." .. reset,
                    min = 400,
                    max = 1600,
                    step = 10,
                    getFunc = function() return 10 or 800 end,
                    setFunc = function(value) end,
                },
            }
        },
    }
end

local function GroupFrameSettings()
    return {
        {
            type = "submenu",
            name = orange .. "Group Frame" .. reset,
            controls = {
                { 
                    type = "description",
                    text = grey .. "Adjust the appearance and behavior of group frames." .. reset,
                    width = "full"
                },
                {
                    type = "checkbox",
                    name = green .. "Enable Group Frame Styling" .. reset,
                    tooltip = grey .. "Apply a modern style to group frames." .. reset,
                    getFunc = function() return true end,
                    setFunc = function(value) end,
                },
                {
                    type = "checkbox",
                    name = green .. "Hide Companion Group Frame" .. reset,
                    tooltip = grey .. "Toggle the visibility of the companion group frame." .. reset,
                    getFunc = function() return true end,
                    setFunc = function(value) end,
                },
                {
                    type = "slider",
                    name = green .. "Adjust Group Frame Width" .. reset,
                    tooltip = grey .. "Set the width of group frames." .. reset,
                    min = 200,
                    max = 600,
                    step = 10,
                    getFunc = function() return 10 or 400 end,
                    setFunc = function(value) end,
                },
            }
        },
    }
end

local function PlayerProgressBarSettings()
    return {
        {
            type = "submenu",
            name = orange .. "Player Progress Bar" .. reset,
            controls = {
                { 
                    type = "description", 
                    text = grey .. "Adjust the appearance of the player progress bar." .. reset, 
                    width = "full" 
                },
                {
                    type = "checkbox",
                    name = green .. "Enable Player Progress Bar Effect" .. reset,
                    tooltip = grey .. "Apply a modern style to the player progress bar." .. reset,
                    getFunc = function() return sv.playerProgressBar end,
                    setFunc = function(value) sv.playerProgressBar = value end,
                    default = SUI.SavedVars.defaults.playerProgressBar,
                    requiresReload = true,
                },
                { 
                    type = "checkbox",
                    name = green .. "Always Show Player Progress Bar" .. reset,
                    tooltip = grey .. "Keep the player progress bar visible at all times." .. reset,
                    getFunc = function() return sv.showPlayerProgressBar end,
                    setFunc = function() SUI.PlayerProgressBar:Toggle() end,
                    default = SUI.SavedVars.defaults.showPlayerProgressBar,
                    requiresReload = false,
                },
            }
        },
    }
end

--------------------------------------------------
-- Settings Panel Creation
--------------------------------------------------
local function SettingsPanel()
    local LAM = LibAddonMenu2
    if not LAM then
        Log("LibAddonMenu2 not found. Settings panel will not be created.")
        return
    end

    local panelData = {
        type                = "panel",
        name                = SUI.menuName,
        displayName         = SUI.displayName,
        author              = SUI.author,
        version             = SUI.version,
        slashCommand        = "/shibui",
        registerForRefresh  = true,
        registerForDefaults = true,
    }

    local optionsTable = {}
    local function appendOptions(tbl)
        for _, s in ipairs(tbl) do
            table.insert(optionsTable, s)
        end
    end

    appendOptions(GeneralSettings())
    appendOptions(DevSettings())
    appendOptions(AttributeBarSettings())
    appendOptions(ActionBarSettings())
    appendOptions(TargetBarSettings())
    appendOptions(CompassSettings())
    appendOptions(GroupFrameSettings())
    appendOptions(PlayerProgressBarSettings())

    LAM:RegisterAddonPanel(SUI.menuName, panelData)
    LAM:RegisterOptionControls(SUI.menuName, optionsTable)
    Log("Settings panel created successfully")
end

--------------------------------------------------
-- Settings Initialization
--------------------------------------------------
function Settings:Initialize()
    sv = SUI.SavedVars.saved
    SettingsPanel()
end