--------------------------------------------------
-- ShibUI - A modern and minimalistic UI.
-- Copyright (C) 2025 Shownie & Ai
--------------------------------------------------
SUI = SUI or {}

--------------------------------------------------
-- Global metadata for ShibUI.    
--------------------------------------------------
SUI.name        = "ShibUI"
SUI.menuName    = "ShibUI Settings"
SUI.displayName = "Shibui User Interface"
SUI.version     = "1.6.0" -- Refactored ShibUI to SUI and local sv references.
SUI.author      = "Shownie & Ai"
SUI.description = "ShibUI is a minimalistic ESO addon that cleans up and modernizes the user interface."

--------------------------------------------------
-- Main entry point for initializing ShibUI.
--------------------------------------------------
function SUI:Initialize()
    local initializers = {
        function() self.Settings:Initialize() end,
        function() self.ReloadUI:Initialize() end,
        function() self.Miscellaneous:Initialize() end,
        function() self.AttributeBar:Initialize() end,
        function() self.TargetBar:Initialize() end,
    }
    for _, init in ipairs(initializers) do
        if type(init) == "function" then
            init()
        end
    end
end

--------------------------------------------------
-- Event handler for when the addon is loaded.
--------------------------------------------------
local function AddonLoaded(eventCode, addonName)
    if addonName ~= SUI.name then return end

    SUI:Initialize()
    SUI.initialize()

    EVENT_MANAGER:UnregisterForEvent(SUI.name, EVENT_ADD_ON_LOADED)
end

EVENT_MANAGER:RegisterForEvent(SUI.name, EVENT_ADD_ON_LOADED, AddonLoaded)