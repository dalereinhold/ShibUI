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
sui.version     = "1.2.0" -- 1.2 updated ActionBar, 1.3 updated Compass
sui.author      = "Shownie & Ai"
sui.description = "ShibUI is a minimalistic ESO addon that cleans up and modernizes the user interface."
-- end of global metadata

--------------------------------------------------
-- Main entry point for initializing ShibUI.
--------------------------------------------------
function sui.initialize()
    local initializers = {
        sui.initializeSettings,
        sui.initializeAttributeBar,
        -- sui.initializeCompass,
        sui.initializeMiscellaneous,
        sui.initializeReloadUI,
        sui.initializeTargetBar,
        sui.initializeUnitFrame,
    }
    for _, init in ipairs(initializers) do
        if type(init) == "function" then
            init()
        end
    end
    
    sui.debug("Initialize", string.format("%s v%s loaded!", sui.displayName, sui.version))

    local em = EVENT_MANAGER
    local statsUpdated = EVENT_STATS_UPDATED
    
    em:UnregisterForEvent("ShibUI_AttributeBarWidth", statsUpdated)
    local layout = sui.saved.attributeBarPyramid and "pyramid" or "shibui"
    sui.applyAttributeBarLayout(layout)
    em:RegisterForEvent("ShibUI_AttributeBarWidth", statsUpdated, function()
        local layout = sui.saved.attributeBarPyramid and "pyramid" or "shibui"
        sui.applyAttributeBarLayout(layout)
    end)
end

--[[function ShibUI:Initialize()
    local initializers = {
        function() self.ActionBar:Initialize() end,
        function() self.Compass:Initialize() end,
    }
    for _, initFunc in ipairs(initializers) do
        if type(initFunc) == "function" then
            initFunc()
        end
    end
end]]--
-- end of main entry point

--------------------------------------------------
-- Event handler for when the addon is loaded.
--------------------------------------------------
local function AddonLoaded(event, name)
    if name ~= sui.name then return end
    sui.initialize()
    ShibUI.ActionBar:Initialize()
    EVENT_MANAGER:UnregisterForEvent(sui.name, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(sui.name, EVENT_ADD_ON_LOADED, AddonLoaded)

--[[local function PlayerActivated(event, activated)
    if not activated then return end
    -- Initialize modules that need to wait until the player is fully loaded.
    EVENT_MANAGER:UnregisterForEvent(sui.name, EVENT_PLAYER_ACTIVATED)
end

EVENT_MANAGER:RegisterForEvent(sui.name, EVENT_PLAYER_ACTIVATED, PlayerActivated)]]--
-- end of event handler