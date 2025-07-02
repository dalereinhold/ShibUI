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
sui.version     = "1.0.46"
sui.author      = "Shownie & Ai"
sui.description = "ShibUI is a minimalistic ESO addon that cleans up and modernizes the user interface."
-- end of global metadata

--------------------------------------------------
-- Main entry point for initializing ShibUI.
--------------------------------------------------
function sui.initialize()
    local initializers = {
        sui.initializeSettings,
        sui.initializeReloadUI,
        sui.initializeMiscellaneous,
        sui.initializeActionBar,
        sui.initializeCompass,
        sui.initializeUnitFrame,
        sui.initializeAttributeBar,
        sui.initializeTargetBar,
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
    local actionSlotUpdated = EVENT_ACTION_SLOT_UPDATED
    local hotbarUpdated = EVENT_ACTION_SLOTS_ACTIVE_HOTBAR_UPDATED

    em:RegisterForEvent("ShibUI_ApplyKeybinds", playerActivated, function()
        sui.initializeActionBar()
        em:UnregisterForEvent("ShibUI_ApplyKeybinds", playerActivated)
    end)
    
    em:RegisterForEvent("ShibUI_ApplyUltimateScale", hotbarUpdated, function()
        sui.applyActionBarSettings()
        em:UnregisterForEvent("ShibUI_ApplyUltimateScale", hotbarUpdated)
    end)

    em:RegisterForEvent("ShibUI_ApplyUltimateScale_Slot", actionSlotUpdated, function(_, slotNum)
        if slotNum == 8 then
            sui.applyActionBarSettings()
            -- Also update the companion ultimate button
            local companionButton = _G["CompanionUltimateButton"]
            if companionButton then
                companionButton:SetScale(sui.saved.ultimateButtonScaled and 1.1 or 1.0)
            end
        end
    end)

    em:UnregisterForEvent("ShibUI_AttributeBarWidth", statsUpdated)
    local layout = sui.saved.attributeBarPyramid and "pyramid" or "shibui"
    sui.applyAttributeBarLayout(layout)
    em:RegisterForEvent("ShibUI_AttributeBarWidth", statsUpdated, function()
        local layout = sui.saved.attributeBarPyramid and "pyramid" or "shibui"
        sui.applyAttributeBarLayout(layout)
    end)
end
-- end of main entry point

--------------------------------------------------
-- Event handler for when the addon is loaded.
--------------------------------------------------
local function onAddonLoaded(event, addonName)
    if addonName ~= sui.name then return end
    sui.initialize()
    EVENT_MANAGER:UnregisterForEvent(sui.name, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(sui.name, EVENT_ADD_ON_LOADED, onAddonLoaded)
-- end of event handler