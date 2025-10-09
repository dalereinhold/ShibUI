--------------------------------------------------
-- ShibUI Player Progress Bar Template
--------------------------------------------------
local SUI = SUI
local sv

SUI.PlayerProgressBar = SUI.PlayerProgressBar or {}
local PlayerProgressBar = SUI.PlayerProgressBar

local Log = function(...) SUI.Debug:Log(...) end

SecurePostHook(PLAYER_PROGRESS_BAR, "RefreshTemplate", function(self)
    if sv and sv.playerProgressBar then
    ApplyTemplateToControl(self.barControl, "SUI_PlayerProgressBarTemplate")
    end
end)


function PlayerProgressBar:Initialize()
    sv = SUI.SavedVars.saved
    if not (sv and sv.playerProgressBar) then
        Log("PlayerProgressBar", "Disabled")
        return    
    end
    Log("PlayerProgressBar", "Initialized")
end