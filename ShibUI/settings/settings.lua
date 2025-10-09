--------------------------------------------------
-- ShibUI Settings Module
--------------------------------------------------
local SUI = SUI
local sv

SUI.Settings = SUI.Settings or {}
local Settings = SUI.Settings

--------------------------------------------------
-- Settings Section Helpers
--------------------------------------------------
local function GeneralSettings()
    return {
        {
            type = "description",
            text = "|cFFA500ShibUI is a minimal and modern interface mod for ESO, created by Shownie in collaboration with AI. It hides or replaces textures to achieve a clean, unobtrusive style.|r\n\n|c7FC97FThe name 'ShibUI' comes from the Japanese word 'shibui' (渋い), which describes a subtle, refined aesthetic — simple, yet elegant.|r",
            width = "full",
        },
        { type = "header", name = "General Settings" },
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
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "Enable Debug Mode",
            tooltip = "Toggle debug messages for troubleshooting. Requires UI reload to take effect.",
            getFunc = function() return sv.debug end,
            setFunc = function(value) sv.debug = value end,
            default = SUI.SavedVars.defaults.debug,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "Enable Player Progress Bar Effect",
            tooltip = "Apply a modern style to the player progress bar.",
            getFunc = function() return sv.playerProgressBar end,
            setFunc = function(value) sv.playerProgressBar = value end,
            default = SUI.SavedVars.defaults.playerProgressBar,
            requiresReload = true,
        }
    }
end

local function AttributeBarSettings()
    return {
        { type = "header", name = "Attribute Bar" },
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
    }
end

local function ActionBarSettings()
    return {
        { type = "header", name = "Action Bar" },
        { 
            type = "checkbox",
            name = "Enable Action Bar Styling",
            tooltip = "Apply a modern style to the action bar and related elements.",
            getFunc = function() return sv.actionBar end,
            setFunc = function(value) sv.actionBar = value end,
            default = SUI.SavedVars.defaults.actionBar,
            requiresReload = true,
        },
    }
end

local function TargetBarSettings()
    return {
        { type = "header", name = "Target Bar" },
        {
            type = "checkbox",
            name = "Enable Target Bar Styling",
            tooltip = "Apply a modern style to the target bar.",
            getFunc = function() return sv.targetBar end,
            setFunc = function(value) sv.targetBar = value end,
            default = SUI.SavedVars.defaults.targetBar,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "Hide Target Bar Out of Combat",
            tooltip = "Toggle the visibility of the target bar when not in combat.",
            getFunc = function() return sv.hideTargetBar end,
            setFunc = function(value) sv.hideTargetBar = value end,
            default = SUI.SavedVars.defaults.hideTargetBar,
        },
    }
end

local function CompassSettings()
    return {
        { type = "header", name = "Compass and Boss Bar" },
        { type = "description", text = "Compass and Boss Bar settings coming in future updates.", width = "full" },
    }
end

local function UnitFrameSettings()
    return {
        { type = "header", name = "Unit Frame" },
        { type = "description", text = "Unit Frame settings coming in future updates.", width = "full" },
    }
end

--------------------------------------------------
-- Settings Panel Creation
--------------------------------------------------
local function SettingsPanel()
    local LAM = LibAddonMenu2
    if not LAM then
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
    appendOptions(AttributeBarSettings())
    appendOptions(ActionBarSettings())
    appendOptions(TargetBarSettings())
    appendOptions(CompassSettings())
    appendOptions(UnitFrameSettings())

    LAM:RegisterAddonPanel(SUI.menuName, panelData)
    LAM:RegisterOptionControls(SUI.menuName, optionsTable)
end

--------------------------------------------------
-- Settings Initialization
--------------------------------------------------
function Settings:Initialize()
    sv = SUI.SavedVars.saved
    SettingsPanel()
end