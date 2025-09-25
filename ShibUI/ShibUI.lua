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

--------------------------------------------------
-- Main entry point for initializing ShibUI.
--------------------------------------------------
function sui.initialize()
    local initializers = {
        sui.initializeSettings,
        sui.initializeAttributeBar,
        sui.initializeMiscellaneous,
        sui.initializeReloadUI,
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

--------------------------------------------------
-- Event handler for when the addon is loaded.
--------------------------------------------------
local function AddonLoaded(event, addon)
    if addon ~= sui.name then return end
    sui.initialize()
    EVENT_MANAGER:UnregisterForEvent(sui.name, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(sui.name, EVENT_ADD_ON_LOADED, AddonLoaded)
