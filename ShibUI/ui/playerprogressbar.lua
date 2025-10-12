--------------------------------------------------
-- ShibUI Player Progress Bar Template
--------------------------------------------------
local SUI = SUI
local sv

SUI.PlayerProgressBar = SUI.PlayerProgressBar or {}
local PlayerProgressBar = SUI.PlayerProgressBar

local Log = function(...) SUI.Debug:Log("PlayerProgressBar", ...) end

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
-- Prevent progress bar from hiding
local originalHide = PLAYER_PROGRESS_BAR.Hide

function PLAYER_PROGRESS_BAR:Hide()
    if not sv.showPlayerProgressBar then
        originalHide(self)
    end
end

function PlayerProgressBar:Toggle()
    sv.showPlayerProgressBar = not sv.showPlayerProgressBar
    if sv.showPlayerProgressBar then
        local barType = CanUnitGainChampionPoints("player") and PPB_CP or PPB_XP
        PLAYER_PROGRESS_BAR:ShowCurrent(barType)
    end
    Log("Progress bar always visible: " .. (sv.showPlayerProgressBar and "ON" or "OFF"))
end

--------------------------------------------------
-- Initialization
--------------------------------------------------
function PlayerProgressBar:Initialize()
    sv = SUI.SavedVars.saved
    if not (sv and sv.playerProgressBar) then
        Log("Disabled")
        return    
    end
    Log("Initialized")
    SLASH_COMMANDS["/togglebar"] = function() PlayerProgressBar:Toggle() end
end