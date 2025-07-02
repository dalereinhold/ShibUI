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

local ultimateButtonDefault = 1.0
local ultimateButtonScaled = 1.1

local function UltimateButtonSize(isScaled)
    local scale = isScaled and ultimateButtonScaled or ultimateButtonDefault
    local ultimateButton = _G["ActionButton8"]
    local companionButton = _G["CompanionUltimateButton"]

    if ultimateButton then
        ultimateButton:SetScale(scale)
    end
    if companionButton then
        companionButton:SetScale(scale)
    end
end
-- end of action bar settings

---------------------------------------------------
-- Public Interface
---------------------------------------------------
function sui.applyActionBarSettings()
    if not sui.saved then return end

    WeaponSwap(sui.saved.weaponSwapVisible)
    KeybindButtons(sui.saved.keybindsVisible)
    UltimateButtonSize(sui.saved.ultimateButtonScaled)

    sui.debug("Action Bar", "Action bar settings applied.")
end
-- end of public interface

---------------------------------------------------
-- Apply Action Bar Settings
---------------------------------------------------
function sui.initializeActionBar()
    if not sui.saved then return end

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