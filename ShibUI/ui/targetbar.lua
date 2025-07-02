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
-- Target Bar Visibility Control
---------------------------------------------------
local lastTargetBarHidden = nil

function sui.targetBarVisibility()
    if not IsPlayerActivated() then return end
    if not UNIT_FRAMES then return end

    local targetFrame = ZO_UnitFrames_GetUnitFrame("reticleover")
    if not targetFrame then return end

    local currentHealth, maxHealth = targetFrame:GetHealth()
    currentHealth = currentHealth or 0
    if currentHealth == 0 then
        targetFrame:SetHiddenForReason("disabled", true)
        if lastTargetBarHidden ~= true then
            sui.debug("Target Bar", "Target bar hidden.")
            lastTargetBarHidden = true
        end
        return
    end

    if not sui.saved or not sui.saved.hideTargetBar then
        targetFrame:SetHiddenForReason("disabled", false)
        if lastTargetBarHidden ~= false then
            sui.debug("Target Bar", "Target bar visible.")
            lastTargetBarHidden = false
        end
        return
    end

    local inCombat = IsUnitInCombat("player")
    local reaction = GetUnitReaction("reticleover")
    local isHostile = (reaction == UNIT_REACTION_HOSTILE)

    if inCombat and isHostile then
        targetFrame:SetHiddenForReason("disabled", false)
        if lastTargetBarHidden ~= false then
            sui.debug("Target Bar", "Target bar visible.")
            lastTargetBarHidden = false
        end
    else
        targetFrame:SetHiddenForReason("disabled", true)
        if lastTargetBarHidden ~= true then
            sui.debug("Target Bar", "Target bar hidden.")
            lastTargetBarHidden = true
        end
    end
end

local em = EVENT_MANAGER
local handler = sui.targetBarVisibility

local events = {
    { name = "ShibUI_TargetBarCombat", id = EVENT_PLAYER_COMBAT_STATE },
    { name = "ShibUI_TargetBarTarget", id = EVENT_RETICLE_TARGET_CHANGED },
}

for _, evt in ipairs(events) do
    em:UnregisterForEvent(evt.name, evt.id)
    em:RegisterForEvent(evt.name, evt.id, handler)
end
-- end of target bar visibility control

---------------------------------------------------
-- Apply Target Bar Settings
---------------------------------------------------
function sui.initializeTargetBar()
    if sui.saved and sui.saved.targetBar then
        BlankTextures()
    else
        DefaultTextures()
    end
    sui.targetBarVisibility()
end
-- end of apply target bar settings