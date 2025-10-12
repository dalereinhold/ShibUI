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
-- Colors for text:
-- Orange: |cFFA500Header|r
-- Light Green: |c7FC97FName|r
--------------------------------------------------
local function GeneralSettings()
    return {
        {
            type = "description",
            text = "|cFFA500ShibUI is a minimal and modern interface mod for ESO, created by Shownie in collaboration with AI. It hides or replaces textures to achieve a clean, unobtrusive style.|r\n\n|c7FC97FThe name 'ShibUI' comes from the Japanese word 'shibui' (渋い), which describes a subtle, refined aesthetic — simple, yet elegant.|r",
            width = "full",
        },
        { type = "header", name = "|cFFA500General Settings|r" },
        {
            type = "checkbox",
            name = "|c7FC97FAccount Wide Settings|r",
            tooltip = "Use the same settings for all characters on this account.",
            getFunc = function() return sv.accountWide end,
            setFunc = function(value) sv.accountWide = value end,
            default = SUI.SavedVars.defaults.accountWide,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "|c7FC97FConfirm Reload UI|r",
            tooltip = "Show a confirmation prompt before reloading the UI.",
            getFunc = function() return sv.confirmReload end,
            setFunc = function(value) sv.confirmReload = value end,
            default = SUI.SavedVars.defaults.confirmReload,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "|c7FC97FEnable Debug Mode|r",
            tooltip = "Toggle debug messages for troubleshooting. Requires UI reload to take effect.",
            getFunc = function() return sv.debug end,
            setFunc = function(value) sv.debug = value end,
            default = SUI.SavedVars.defaults.debug,
            requiresReload = true,
        },
    }
end

local function AttributeBarSettings()
    return {
        { type = "header", name = "|cFFA500Attribute Bar|r" },
        { type = "description", text = "Adjust the appearance and behavior of the attribute bar.", width = "full" },
        {
            type = "checkbox",
            name = "|c7FC97FEnable Attribute Bar|r",
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
            name = "|c7FC97FPyramid Layout|r",
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
            name = "|c7FC97FAttribute Bar Width Mode|r",
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
            name = "|c7FC97FAttribute Bar Layout|r",
            tooltip = "Default layout matches the game's default. Pyramid stacks Health on top of Magicka and Stamina. ShibUI stacks and widens attributes horizontally.",
            choices = { "Default", "Pyramid", "ShibUI" },
            choicesValues = { "default", "pyramid", "shibui" },
            getFunc = function() return true end,
            setFunc = function(value) end,
        },
    }
end

local function ActionBarSettings()
    return {
        { type = "header", name = "|cFFA500Action Bar|r" },
        { type = "description", text = "Adjust the appearance and behavior of the action bar and related elements.", width = "full" },
        { 
            type = "checkbox",
            name = "|c7FC97FEnable Action Bar Styling|r",
            tooltip = "Apply a modern style to the action bar and related elements.",
            getFunc = function() return sv.actionBar end,
            setFunc = function(value) sv.actionBar = value end,
            default = SUI.SavedVars.defaults.actionBar,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "|c7FC97FHide Weapon Swap Icon|r",
            tooltip = "Toggle the visibility of the weapon swap icon on the action bar.",
            getFunc = function() return true end,
            setFunc = function(value) end,
        },
        {
            type = "checkbox",
            name = "|c7FC97FHide Keybindings|r",
            tooltip = "Toggle the visibility of keybindings on the action bar.",
            getFunc = function() return true end,
            setFunc = function(value) end,
        },
        {
            type = "checkbox",
            name = "|c7FC97FUse Scaled Ultimate Slots|r",
            tooltip = "Toggle the use of scaled ultimate slots on the action bar.",
            getFunc = function() return true end,
            setFunc = function(value) end,
        },
        {
            type = "slider",
            name = "|c7FC97FAdjust Horizontal Action Bar Position|r",
            tooltip = "Fine-tune the horizontal position of the action bar.",
            min = -100,
            max = 100,
            step = 1,
            getFunc = function() return 1 or 50 end,
            setFunc = function(value) end,
        },
        {
            type = "checkbox",
            name = "|c7FC97FBackbar Numeric countdown|r",
            tooltip = "Show numeric countdown on backbar abilities.",
            getFunc = function() return true end,
            setFunc = function(value) end,
        },
    }
end

local function TargetBarSettings()
    return {
        { type = "header", name = "|cFFA500Target Bar|r" },
        { type = "description", text = "Adjust the appearance and behavior of the target bar.", width = "full" },
        {
            type = "checkbox",
            name = "|c7FC97FEnable Target Bar Styling|r",
            tooltip = "Apply a modern style to the target bar.",
            getFunc = function() return sv.targetBar end,
            setFunc = function(value) sv.targetBar = value end,
            default = SUI.SavedVars.defaults.targetBar,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "|c7FC97FHide Target Bar Out of Combat|r",
            tooltip = "Toggle the visibility of the target bar when not in combat.",
            getFunc = function() return sv.hideTargetBar end,
            setFunc = function(value) sv.hideTargetBar = value end,
            default = SUI.SavedVars.defaults.hideTargetBar,
            requiresReload = true,
        },
    }
end

local function CompassSettings()
    return {
        { type = "header", name = "|cFFA500Compass and Boss Bar|r" },
        {type = "description", text = "Adjust the appearance of the compass and boss bar.", width = "full" },
        {
            type = "checkbox",
            name = "|c7FC97FEnable Compass and Boss Bar Styling|r",
            tooltip = "Apply a modern style to the compass and boss bar.",
            getFunc = function() return true end,
            setFunc = function(value) end,
        },
        {
            type = "slider",
            name = "|c7FC97FAdjust Compass/Boss Bar Width|r",
            tooltip = "Set the width of the compass and boss bar.",
            min = 400,
            max = 1600,
            step = 10,
            getFunc = function() return 10 or 800 end,
            setFunc = function(value) end,
        },
    }
end

local function GroupFrameSettings()
    return {
        { type = "header", name = "|cFFA500Group Frame|r" },
        { type = "description", text = "Adjust the appearance and behavior of group frames.", width = "full" },
        {
            type = "checkbox",
            name = "|c7FC97FEnable Group Frame Styling|r",
            tooltip = "Apply a modern style to group frames.",
            getFunc = function() return true end,
            setFunc = function(value) end,
        },
        {
            type = "checkbox",
            name = "|c7FC97FHide Companion Group Frame|r",
            tooltip = "Toggle the visibility of the companion group frame.",
            getFunc = function() return true end,
            setFunc = function(value) end,
        },
        {
            type = "slider",
            name = "|c7FC97FAdjust Group Frame Width|r",
            tooltip = "Set the width of group frames.",
            min = 200,
            max = 600,
            step = 10,
            getFunc = function() return 10 or 400 end,
            setFunc = function(value) end,
        },
    }
end

local function PlayerProgressBarSettings()
    return {
        { type = "header", name = "|cFFA500Player Progress Bar|r" },
        { type = "description", text = "Adjust the appearance of the player progress bar.", width = "full" },
        {
            type = "checkbox",
            name = "|c7FC97FEnable Player Progress Bar Effect|r",
            tooltip = "Apply a modern style to the player progress bar.",
            getFunc = function() return sv.playerProgressBar end,
            setFunc = function(value) sv.playerProgressBar = value end,
            default = SUI.SavedVars.defaults.playerProgressBar,
            requiresReload = true,
        },
        { 
            type = "checkbox",
            name = "|c7FC97FAlways Show Player Progress Bar|r",
            tooltip = "Keep the player progress bar visible at all times.",
            getFunc = function() return sv.showPlayerProgressBar end,
            setFunc = function() SUI.PlayerProgressBar:Toggle() end,
            default = SUI.SavedVars.defaults.showPlayerProgressBar,
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