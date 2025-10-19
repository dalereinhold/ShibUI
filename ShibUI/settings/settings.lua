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
            name = "General Settings "},
        { 
            type = "description", 
            text = "General settings for ShibUI.", 
            width = "full" },
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
            tooltip = "Toggle debug messages for troubleshooting. Requires UI reload to take effect.",
            getFunc = function() return sv.debug end,
            setFunc = function(value) 
                sv.debug = value
                SUI.Debug:Initialize() 
            end,
            default = SUI.SavedVars.defaults.debug,
            requiresReload = false,
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
            type = "description",
            text = "Adjust the appearance and behavior of the attribute bar.",
            width = "full"
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
            type = "description",
            text = "Adjust the appearance and behavior of the action bar and related elements.",
            width = "full"
        },
        { 
            type = "checkbox",
            name = "Enable Action Bar Styling",
            tooltip = "Apply a modern style to the action bar and related elements.",
            getFunc = function() return sv.actionBar end,
            setFunc = function(value) sv.actionBar = value end,
            default = SUI.SavedVars.defaults.actionBar,
            requiresReload = true,
        },
        {
            type = "checkbox",
            name = "Hide Weapon Swap Icon",
            tooltip =  "Toggle the visibility of the weapon swap icon on the action bar.",
            getFunc = function() return true end,
            setFunc = function(value) end,
            width = "half",
        },
        {
            type = "checkbox",
            name =  "Hide Keybindings" ,
            tooltip =  "Toggle the visibility of keybindings on the action bar.",
            getFunc = function() return true end,
            setFunc = function(value) end,
            width = "half",
        },
        {
            type = "checkbox",
            name = "Use Scaled Ultimate Slots",
            tooltip = "Toggle the use of scaled ultimate slots on the action bar.",
            getFunc = function() return true end,
            setFunc = function(value) end,
            width = "half",
        },
        {
            type = "slider",
            name = "Adjust Horizontal Action Bar Position",
            tooltip = "Fine-tune the horizontal position of the action bar.",
            min = -100,
            max = 100,
            step = 1,
            getFunc = function() return 1 or 50 end,
            setFunc = function(value) end,
            width = "half",
        },
        {
            type = "checkbox",
            name = "Backbar Numeric countdown",
            tooltip = "Show numeric countdown on backbar abilities.",
            getFunc = function() return true end,
            setFunc = function(value) end,
            width = "half",
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
            type = "description",
            text = "Adjust the appearance and behavior of the target bar.",
            width = "full"
        },
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
            setFunc = function(value)
                sv.hideTargetBar = value
                SUI.TargetBar:Toggle()
            end,
            default = SUI.SavedVars.defaults.hideTargetBar,
            requiresReload = false,
        },
    }
end

local function CompassSettings()
    return {
        {
            type = "header",
            name = "Compass and Boss Bar",
        },
        {
            type = "description",
            text = "Adjust the appearance of the compass and boss bar.",
            width = "full" 
        },
        {
            type = "checkbox",
            name = "Enable Compass and Boss Bar Styling",
            tooltip = "Apply a modern style to the compass and boss bar.",
            getFunc = function() return true end,
            setFunc = function(value) end,
            width = "half",
        },
        {
            type = "slider",
            name = "Adjust Compass/Boss Bar Width",
            tooltip = "Set the width of the compass and boss bar.",
            min = 400,
            max = 1600,
            step = 10,
            getFunc = function() return 10 or 800 end,
            setFunc = function(value) end,
            width = "half",
        },
    }
end

local function GroupFrameSettings()
    return {
        {
            type = "header",
            name = "Group Frame",
        },
        {
            type = "description",
            text = "Adjust the appearance and behavior of group frames.",
        },
        {
            type = "checkbox",
            name = "Enable Group Frame Styling",
            tooltip = "Apply a modern style to group frames.",
            getFunc = function() return true end,
            setFunc = function(value) end,
            width = "half",
        },
        {
            type = "checkbox",
            name = "Hide Companion Group Frame",
            tooltip = "Toggle the visibility of the companion group frame.",
            getFunc = function() return true end,
            setFunc = function(value) end,
            width = "half",
        },
        {
            type = "slider",
            name = "Adjust Group Frame Width",
            tooltip = "Set the width of group frames.",
            min = 200,
            max = 600,
            step = 10,
            getFunc = function() return 10 or 400 end,
            setFunc = function(value) end,
            width = "half",
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
            type = "description",
            text = "Adjust the appearance of the player progress bar.",
        },
        {
            type = "checkbox",
            name = "Enable Player Progress Bar Effect",
            tooltip = "Apply a modern style to the player progress bar.",
            getFunc = function() return sv.playerProgressBar end,
            setFunc = function(value) sv.playerProgressBar = value end,
            default = SUI.SavedVars.defaults.playerProgressBar,
            requiresReload = true,
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
            requiresReload = false,
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