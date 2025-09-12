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
sui.version     = "1.2.47" -- Version bump
sui.author      = "Shownie & Ai"
sui.description = "ShibUI is a minimalistic ESO addon that cleans up and modernizes the user interface."
-- end of global metadata

--------------------------------------------------
-- Main entry point for initializing ShibUI.
--------------------------------------------------
local initializers = {
    function() ShibUI.ActionBar:Initialize() end,
}

function ShibUI:Initialize()
    for _, initFunc in ipairs(initializers) do
        if type(initFunc) == "function" then
            initFunc()
        end
    end
end

function sui.initialize()
    local initializers = {
        sui.initializeSettings,
        -- sui.initializeActionBar, -- tweaks for v1.1.47
        sui.initializeAttributeBar,
        sui.initializeCompass,
        sui.initializeMiscellaneous,
        sui.initializeReloadUI,
        sui.initializeTargetBar, -- tweaks for v1.1.47
        sui.initializeUnitFrame,
    }
    for _, init in ipairs(initializers) do
        if type(init) == "function" then
            init()
        end
    end
    
    sui.debug("Initialize", string.format("%s v%s loaded!", sui.displayName, sui.version))

    local em = EVENT_MANAGER
    local playerActivated = EVENT_PLAYER_ACTIVATED
    local statsUpdated = EVENT_STATS_UPDATED

    --[[em:RegisterForEvent("ShibUI_ApplyKeybinds", playerActivated, function()
        sui.initializeActionBar()
        em:UnregisterForEvent("ShibUI_ApplyKeybinds", playerActivated)
    end)
    
    em:UnregisterForEvent("ShibUI_AttributeBarWidth", statsUpdated)
    local layout = sui.saved.attributeBarPyramid and "pyramid" or "shibui"
    sui.applyAttributeBarLayout(layout)
    em:RegisterForEvent("ShibUI_AttributeBarWidth", statsUpdated, function()
        local layout = sui.saved.attributeBarPyramid and "pyramid" or "shibui"
        sui.applyAttributeBarLayout(layout)
    end)]]--
end
-- end of main entry point

--------------------------------------------------
-- Event handler for when the addon is loaded.
--------------------------------------------------
local function onAddonLoaded(event, addonName)
    if addonName ~= sui.name then return end
    sui.initialize()
    ShibUI:Initialize()
    EVENT_MANAGER:UnregisterForEvent(sui.name, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(sui.name, EVENT_ADD_ON_LOADED, onAddonLoaded)
-- end of event handler