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
--------------------------------------------------


local function GeneralSettings()
    return {
        {
            type = "description",
            text = "ShibUI is a minimal and modern interface mod for ESO, created by Shownie in collaboration with AI. It hides or replaces textures to achieve a clean, unobtrusive style.\n\nThe name 'ShibUI' comes from the Japanese word 'shibui' (渋い), which describes a subtle, refined aesthetic — simple, yet elegant.",
            width = "full",
        },
        { 
            type = "header",
            name = "General Settings "
        },
        {
            type = "checkbox",
            name = "Account Wide Settings",
            tooltip = "Use the same settings for all characters on this account.",
            getFunc = function() return sv.accountWide end,
            setFunc = function(value) sv.accountWide = value end,
            default = SUI.SavedVars.defaults.accountWide,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "Confirm Reload UI",
            tooltip = "Show a confirmation prompt before reloading the UI.",
            getFunc = function() return sv.confirmReload end,
            setFunc = function(value) sv.confirmReload = value end,
            default = SUI.SavedVars.defaults.confirmReload,
            requiresReload = false,
        },
        {
            type = "checkbox",
            name = "Enable Debug Mode",
            tooltip = "Toggle debug messages for troubleshooting.",
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
            type = "header",
            name = "Attribute Bar Layout Preview",
        },
        {
            type = "checkbox",
            name = "Enable Attribute Bar",
            tooltip = "Removes textures and applies a modern style to the attribute bar.",
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
            name = "Pyramid Layout",
            tooltip = "Stack attribute bars in a pyramid style (Health on top of Magicka and Stamina).",
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
            name = "Attribute Bar Width Mode",
            tooltip = "Choose Normal or Expanded for fixed width, or Default for dynamic width based on current stats.",
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
            name = "Attribute Bar Layout",
            tooltip = "Default layout matches the game's default. Pyramid stacks Health on top of Magicka and Stamina. ShibUI stacks and widens attributes horizontally.",
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
end

local function ActionBarSettings()
    return {
        { 
            type = "header",
            name = "Action Bar",
        },
        {
            type = "checkbox",
            name = "Show Weapon Swap Icon",
            tooltip =  "Toggle the visibility of the weapon swap icon on the action bar.",
            getFunc = function() return sv.showWeaponSwap end,
            setFunc = function(value) 
                sv.showWeaponSwap = value 
                SUI.ActionBar:ApplyWeaponSwapVisibility()
            end,
            default = SUI.SavedVars.defaults.showWeaponSwap,
        },
        {
            type = "checkbox",
            name =  "Hide Keybindings",
            tooltip =  "Toggle the visibility of keybindings on the action bar.",
            getFunc = function() return sv.showKeybindings end,
            setFunc = function(value) 
                sv.showKeybindings = value 
                SUI.ActionBar:ToggleKeybindings()
            end,
            default = SUI.SavedVars.defaults.showKeybindings,
        },
        {
            type = "checkbox",
            name = "Use Scaled Ultimate Slots",
            tooltip = "Toggle the use of scaled ultimate slots on the action bar.",
            getFunc = function() return true end,
            setFunc = function(value) end,
        },
    }
end

local function TargetBarSettings()
    return {
        {
            type = "header",
            name = "Target Bar",
        },
        {
            type = "checkbox",
            name = "Show Only Hostile Targets",
            tooltip = "Display only hostile targets on the target bar.",
            getFunc = function() return sv.showHostileOnly end,
            setFunc = function(value) sv.showHostileOnly = value end,
            default = SUI.SavedVars.defaults.showHostileOnly,
        },
    }
end

local function PlayerProgressBarSettings()
    return {
        {
            type = "header",
            name = "Player Progress Bar",
        },
        { 
            type = "checkbox",
            name = "Always Show Player Progress Bar",
            tooltip = "Keep the player progress bar visible at all times.",
            getFunc = function() return sv.showPlayerProgressBar end,
            setFunc = function(value)
                sv.showPlayerProgressBar = value 
                SUI.PPB:Toggle()
            end,
            default = SUI.SavedVars.defaults.showPlayerProgressBar,
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
        for _, i in ipairs(tbl) do
            table.insert(optionsTable, i)
        end
    end

    appendOptions(GeneralSettings())
    appendOptions(AttributeBarSettings())
    appendOptions(ActionBarSettings())
    appendOptions(TargetBarSettings())
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