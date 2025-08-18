--------------------------------------------------
-- ShibUI Action Bar Module
--------------------------------------------------

local sui = ShibUI

---------------------------------------------------
-- Texture Redirection for Action Bar
---------------------------------------------------
local blankTexture = "/esoui/art/icons/heraldrycrests_misc_blank_01.dds"
local basePath = "/esoui/art/actionbar/"

local defaultTextures = {
    basePath .. "ability_ultimate_framedecobg.dds",
    basePath .. "abilitycooldowninsert.dds",
    basePath .. "abilityframe_buff.dds",
    basePath .. "abilityframe_debuff.dds",
    basePath .. "abilityframe64_down.dds",
    basePath .. "abilityframe64_glow.dds",
    basePath .. "abilityframe64_up.dds",
    basePath .. "abilityinset_buffdebuff.dds",
    basePath .. "backrow_abilityframe_blank.dds",
    basePath .. "backrow_abilityframe_notimer.dds",
    basePath .. "backrow_abilityframe_overlay.dds",
    basePath .. "backrow_abilityframe.dds",
    basePath .. "passiveabilityframe_round_down.dds",
    basePath .. "passiveabilityframe_round_empty.dds",
    basePath .. "passiveabilityframe_round_locked.dds",
    basePath .. "passiveabilityframe_round_up.dds",
}

local function BlankTextures()
    for _, tex in ipairs(defaultTextures) do
        RedirectTexture(tex, blankTexture)
    end
    sui.debug("Action Bar", "Textures removed.")
end

local function DefaultTextures()
    for _, tex in ipairs(defaultTextures) do
        RedirectTexture(tex, tex)
    end
    sui.debug("Action Bar", "Default textures restored.")
end
-- end of texture control

---------------------------------------------------
-- Action Bar settings
---------------------------------------------------
local function WeaponSwap(isVisible)
    local weaponSwapButton = ZO_ActionBar1WeaponSwap
    if not weaponSwapButton then return end
    weaponSwapButton:SetAlpha(isVisible and 1 or 0)
end

local function KeybindButtons(isVisible)
    local alpha = isVisible and 1 or 0
    local hidden = not isVisible
    for i = 3, 8 do
        local label = _G["ActionButton"..i.."ButtonText"]
        if label then
            label:SetAlpha(alpha)
            label:SetHidden(hidden)
        end
    end
    local quickslotLabel = _G['QuickslotButtonButtonText']
    if quickslotLabel then
        quickslotLabel:SetAlpha(alpha)
        quickslotLabel:SetHidden(hidden)
    end
    local companionLabel = _G['CompanionUltimateButtonButtonText']
    if companionLabel then
        companionLabel:SetAlpha(alpha)
        companionLabel:SetHidden(hidden)
    end
end

local function ApplyUltimateScale()
    local isScaled = sui.saved.ultimateButtonScaled
    local targetScale = isScaled and 1.2 or 1

    for _, buttonName in ipairs({ "ActionButton8", "CompanionUltimateButton" }) do
        local btn = _G[buttonName]
        if btn then
            if targetScale <= 1 then
                -- Always reset to normal when scaling is off
                btn:SetScale(1)
            else
                -- Reset first, then upscale to target
                btn:SetScale(0.9)
                zo_callLater(function()
                    btn:SetScale(targetScale)
                end, 0)
            end
        end
    end
end

function sui.applyActionBarSettings()
    if not sui.saved then return end
    WeaponSwap(sui.saved.weaponSwapVisible)
    KeybindButtons(sui.saved.keybindsVisible)
    ApplyUltimateScale()
    sui.debug("Action Bar", "Action bar settings applied.")
end

function sui.registerActionBarEvents()
    local em = EVENT_MANAGER
    local playerActivated = EVENT_PLAYER_ACTIVATED
    local weaponSwap = EVENT_ACTIVE_WEAPON_PAIR_CHANGED

    em:RegisterForEvent("SUI_UltimateScale_PlayerActivated", playerActivated, ApplyUltimateScale)
    em:RegisterForEvent("SUI_ActionBar_WeaponSwap", weaponSwap, ApplyUltimateScale)
end

function sui.initializeActionBar()
    if not sui.saved then return end
    sui.registerActionBarEvents()
    if sui.saved.actionBar then
        BlankTextures()
        ZO_ActionBar1KeybindBG:SetAlpha(0)
    else
        DefaultTextures()
        ZO_ActionBar1KeybindBG:SetAlpha(1)
    end
    sui.applyActionBarSettings()
end
-- end of apply action bar settings