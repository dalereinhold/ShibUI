--------------------------------------------------
-- ShibUI - A modern and minimalistic UI.
-- Copyright (C) 2025 Shownie & Ai
--------------------------------------------------

ShibUI = ShibUI or {}
local sui = ShibUI

--------------------------------------------------
-- Global metadata for ShibUI.    
--------------------------------------------------
sui.name        = "ShibUI"
sui.menuName    = "ShibUI Settings"
sui.displayName = "Shibui User Interface"
sui.version     = "1.5.0" -- code cleanup and settings rework
sui.author      = "Shownie & Ai"
sui.description = "ShibUI is a minimalistic ESO addon that cleans up and modernizes the user interface."

sui.defaults = {
    -- General
    accountWide = true,
    confirmReload = true,
    
    -- Attribute Bar
    attributeBar = true,
    attributeBarPyramid = false,
    attributeBarSize = "default",

    -- Target Bar
    targetBar = true,
    hideTargetBar = true,
}

--------------------------------------------------
-- Main entry point for initializing ShibUI.
--------------------------------------------------
function sui.initialize()
    local initializers = {
        sui.initializeAttributeBar,
        sui.initializeTargetBar,
    }
    for _, init in ipairs(initializers) do
        if type(init) == "function" then
            init()
        end
    end
    EVENT_MANAGER:UnregisterForEvent("ShibUI_AttributeBarWidth", EVENT_STATS_UPDATED)
    local layout = sui.saved.attributeBarPyramid and "pyramid" or "shibui"
    sui.applyAttributeBarLayout(layout)

    EVENT_MANAGER:RegisterForEvent("ShibUI_AttributeBarWidth", EVENT_STATS_UPDATED, function()
        local layout = sui.saved.attributeBarPyramid and "pyramid" or "shibui"
        sui.applyAttributeBarLayout(layout)
    end)
end

function ShibUI:Initialize()
    local initializers = {
        function() self.Settings:Initialize() end,
        function() self.ReloadUI:Initialize() end,
        function() self.Miscellaneous:Initialize() end,
    }
    for _, initFunc in ipairs(initializers) do
        if type(initFunc) == "function" then
            initFunc()
        end
    end
end

--------------------------------------------------
-- Event handler for when the addon is loaded.
--------------------------------------------------
local function AddonLoaded(event, addon)
    if addon ~= sui.name then return end
    
    sui.accountSaved = ZO_SavedVars:NewAccountWide("suiSavedVars", 1, nil, sui.defaults)
    sui.characterSaved = ZO_SavedVars:New("suiSavedVars", 1, nil, sui.defaults)

    local accountWide = sui.accountSaved.accountWide or false
    sui.saved = accountWide and sui.accountSaved or sui.characterSaved

    ShibUI:Initialize()
    sui.initialize()

    EVENT_MANAGER:UnregisterForEvent(sui.name, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(sui.name, EVENT_ADD_ON_LOADED, AddonLoaded)