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
-- Simple and safe always visible toggle
local originalOnFadeOutComplete = PLAYER_PROGRESS_BAR.OnFadeOutComplete

function PLAYER_PROGRESS_BAR:OnFadeOutComplete()
    local oldBarMode = self.barMode
    
    self:SetBarMode(nil)
    self.barType = nil
   
    self:SetBarState(ZO_STATE.HIDDEN)
    self.control:SetHidden(true)

    local nextAnnouncementHasBar = CENTER_SCREEN_ANNOUNCE:DoesNextMessageHaveBarParams()

    if oldBarMode == PPB_MODE_INCREASE then
        self:ClearIncreaseData()
        self:FireCallbacks("Complete")
    end

    -- Modified logic: show if baseType exists OR if always visible is on
    if((self.baseType or sv.showPlayerProgressBar) and not nextAnnouncementHasBar and not self.pendingShowIncrease) then
        local barType = self.baseType or (CanUnitGainChampionPoints("player") and PPB_CP or PPB_XP)
        self:ShowCurrent(barType)
    end
    
    self:FireCallbacks("FadeOutComplete")
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