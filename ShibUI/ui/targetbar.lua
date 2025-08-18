--------------------------------------------------
-- ShibUI Target Bar Module
--------------------------------------------------

local sui = ShibUI

---------------------------------------------------
-- Texture Redirection for Target Bar
---------------------------------------------------
local blankTexture = "/esoui/art/icons/heraldrycrests_misc_blank_01.dds"
local basePath = "/esoui/art/unitattributevisualizer/"

local defaultTextures = {
    basePath .. "targetbar_dynamic_bg.dds",
    basePath .. "targetbar_dynamic_frame.dds",
}

local function BlankTextures()
    for _, tex in ipairs(defaultTextures) do
        RedirectTexture(tex, blankTexture)
    end
    sui.debug("Target Bar", "Textures removed.")
end

local function DefaultTextures()
    for _, tex in ipairs(defaultTextures) do
        RedirectTexture(tex, tex)
    end
    sui.debug("Target Bar", "Default textures restored.")
end
-- end of texture control

---------------------------------------------------
-- Target Bar Visibility Control (with delay)
---------------------------------------------------
local lastTargetBarHidden = nil
local hideDelayMS = 3000 -- 3 seconds
local hideTimer = nil

local function setTargetBarHidden(hidden)
    local targetFrame = ZO_UnitFrames_GetUnitFrame("reticleover")
    if not targetFrame then return end
    targetFrame:SetHiddenForReason("disabled", hidden)
    if lastTargetBarHidden ~= hidden then
        sui.debug("Target Bar", hidden and "Hidden" or "Visible")
        lastTargetBarHidden = hidden
    end
end

local function updateVisibility(force)
    if not IsPlayerActivated() or not UNIT_FRAMES then return end
    local targetFrame = ZO_UnitFrames_GetUnitFrame("reticleover")
    if not targetFrame then return end

    local currentHealth = select(1, targetFrame:GetHealth()) or 0
    if currentHealth == 0 then
        setTargetBarHidden(true)
        return
    end

    if not sui.saved or not sui.saved.hideTargetBar then
        setTargetBarHidden(false)
        return
    end

    local inCombat = IsUnitInCombat("player")
    local isHostile = (GetUnitReaction("reticleover") == UNIT_REACTION_HOSTILE)

    if inCombat and isHostile then
        -- Cancel pending hide
        if hideTimer then hideTimer = nil end
        setTargetBarHidden(false)
    else
        if force then
            setTargetBarHidden(true)
        else
            if not hideTimer then
                hideTimer = zo_callLater(function()
                    setTargetBarHidden(true)
                    hideTimer = nil
                end, hideDelayMS)
            end
        end
    end
end
-- end of target bar visibility control

---------------------------------------------------
-- Event Handling
---------------------------------------------------
local em = EVENT_MANAGER

-- Combat state handler (controls delay)
em:RegisterForEvent("ShibUI_TargetBarCombat", EVENT_PLAYER_COMBAT_STATE, function(_, inCombat)
    if inCombat then
        updateVisibility(true) -- show instantly when entering combat
    else
        updateVisibility(false) -- hide after delay when leaving combat
    end
end)

-- Target change handler (instant show/hide when needed)
em:RegisterForEvent("ShibUI_TargetBarTarget", EVENT_RETICLE_TARGET_CHANGED, function()
    updateVisibility(true)
end)
-- end of target change handler

---------------------------------------------------
-- Apply Target Bar Settings
---------------------------------------------------
function sui.initializeTargetBar()
    if sui.saved and sui.saved.targetBar then
        BlankTextures()
    else
        DefaultTextures()
    end
    -- sui.targetBarVisibility()
    updateVisibility(true) -- Force update visibility on initialization
end
-- end of apply target bar settings