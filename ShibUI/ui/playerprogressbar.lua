--------------------------------------------------
-- ShibUI Player Progress Bar Template
--------------------------------------------------
local SUI = SUI
local sv

SUI.PlayerProgressBar = SUI.PlayerProgressBar or {}
local PlayerProgressBar = SUI.PlayerProgressBar

local Log = function(...) SUI.Debug:Log(...) end

--------------------------------------------------
-- XML Template Application
-- local PLAYER_PROGRESS_BAR = "ZO_PlayerProgressBar"
--------------------------------------------------
SecurePostHook(PLAYER_PROGRESS_BAR, "RefreshTemplate", function(self)
    if sv and sv.playerProgressBar then
    ApplyTemplateToControl(self.barControl, "SUI_PlayerProgressBarTemplate")
    end
end)

--------------------------------------------------
-- Runtime functions
--------------------------------------------------
-- Simple Progress Bar Always Visible Toggle
PLAYER_PROGRESS_BAR.alwaysVisible = sv.showPlayerProgressBar

function PlayerProgressBar:ToggleVisibility()
    sv.showPlayerProgressBar = not sv.showPlayerProgressBar
    PLAYER_PROGRESS_BAR.alwaysVisible = sv.showPlayerProgressBar

    if sv.showPlayerProgressBar then
        local barType = CanUnitGainChampionPoints("player") and PPB_CP or PPB_XP
        PLAYER_PROGRESS_BAR:ShowCurrent(barType)
        d("Progress bar: ON")
    else
        PLAYER_PROGRESS_BAR:Hide()
        d("Progress bar: OFF")
    end
end

--------------------------------------------------
-- Initialization
--------------------------------------------------
function PlayerProgressBar:Initialize()
    sv = SUI.SavedVars.saved
    if not (sv and sv.playerProgressBar) then
        Log("PlayerProgressBar", "Disabled")
        return    
    end
    Log("PlayerProgressBar", "Initialized")
end