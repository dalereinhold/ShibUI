--------------------------------------------------
-- ShibUI Target Bar Module
--------------------------------------------------
local SUI = SUI
local sv

SUI.TargetBar = SUI.TargetBar or {}
local TargetBar = SUI.TargetBar

local Log = function(...) SUI.Debug:Log("Target Bar", ...) end

--------------------------------------------------
-- Target Bar XML Template
--------------------------------------------------
local TARGET_UNIT_FRAME = "ZO_TargetUnitFrame"

SecurePostHook("CreateControlFromVirtual", function(name, _, template, suffix)
    if template == TARGET_UNIT_FRAME then
        local control = GetControl(name, suffix)
        ApplyTemplateToControl(control, "SUI_TargetUnitFrame")
    end
end)

---------------------------------------------------
-- Target Bar Visibility Control (with delay)
---------------------------------------------------
local lastTargetBarHidden = nil
local hideDelayMS = 3000 -- 3 seconds
local hideTimer = nil

local function SetTargetBarHidden(hidden)
    local targetFrame = ZO_UnitFrames_GetUnitFrame("reticleover")
    if not targetFrame then return end
    targetFrame:SetHiddenForReason("disabled", hidden)
    if lastTargetBarHidden ~= hidden then
        lastTargetBarHidden = hidden
    end
end

local function UpdateVisibility(force)
    if not IsPlayerActivated() or not UNIT_FRAMES then return end
    local targetFrame = ZO_UnitFrames_GetUnitFrame("reticleover")
    if not targetFrame then return end

    local currentHealth = select(1, targetFrame:GetHealth()) or 0
    if currentHealth == 0 then
        SetTargetBarHidden(true)
        return
    end

    if not sv or not sv.hideTargetBar then
        SetTargetBarHidden(false)
        return
    end

    local inCombat = IsUnitInCombat("player")
    local isHostile = (GetUnitReaction("reticleover") == UNIT_REACTION_HOSTILE)

    if inCombat and isHostile then
        -- Cancel pending hide
        if hideTimer then hideTimer = nil end
        SetTargetBarHidden(false)
    else
        if force then
            SetTargetBarHidden(true)
        else
            if not hideTimer then
                hideTimer = zo_callLater(function()
                    SetTargetBarHidden(true)
                    hideTimer = nil
                end, hideDelayMS)
            end
        end
    end
end

function TargetBar:Toggle()
    sv.hideTargetBar = not sv.hideTargetBar
    if not sv.hideTargetBar then
        SetTargetBarHidden(false)
    else
        SetTargetBarHidden(true)
    end
    Log("Target Bar always visible: " .. (sv.hideTargetBar and "ON" or "OFF"), 0)
end

---------------------------------------------------
-- Event Handling
---------------------------------------------------
-- Combat state handler (controls delay)
EVENT_MANAGER:RegisterForEvent("ShibUI_TargetBarCombat", EVENT_PLAYER_COMBAT_STATE, function(_, inCombat)
    if inCombat then
        UpdateVisibility(true) -- show instantly when entering combat
    else
        UpdateVisibility(false) -- hide after delay when leaving combat
    end
end)

-- Target change handler (instant show/hide when needed)
EVENT_MANAGER:RegisterForEvent("ShibUI_TargetBarTarget", EVENT_RETICLE_TARGET_CHANGED, function()
    UpdateVisibility(true)
end)

---------------------------------------------------
-- Apply Target Bar Settings
---------------------------------------------------
function TargetBar:Initialize()
    sv = SUI.SavedVars.saved
    if not sv or not sv.targetBar then
        Log("Disabled via settings.")
        return
    end
    if not sv.hideTargetBar then
        Log("Hide out of combat disabled via settings.")
    end
    UpdateVisibility(true) -- Force update visibility on initialization
    SetTargetBarHidden(sv.hideTargetBar) -- Apply initial hidden state
    Log("Initialized successfully.")
    ZO_CreateStringId("SI_BINDING_NAME_TOGGLE_TARGET_BAR_KEYBIND", "Toggle Target Bar")
    SLASH_COMMANDS["/tbh"] = function() self:Toggle() end
end