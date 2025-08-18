--------------------------------------------------
-- ShibUI Action Bar Module
--------------------------------------------------
local sui = ShibUI
local ApplyTemplateToControl = ApplyTemplateToControl

-- Apply templates to the entire action bar set
local function ApplySUIActionBarTemplates()
    for i = 3, 8 do
        local btn = _G["ActionButton" .. i]
        if btn then
            ApplyTemplateToControl(btn, "SUI_ActionButtonBlank")
        end
    end
end

-- Ultimate button sizing via templates
local function ApplyUltimateTemplate()
    local saved = sui.saved
    if not saved then return end

    local template = saved.ultimateButtonScaled and "SUI_UltimateButtonScaled" or "SUI_UltimateButtonNormal"
    for _, name in ipairs({ "ActionButton8", "CompanionUltimateButton" }) do
        local btn = _G[name]
        if btn then
            ApplyTemplateToControl(btn, template)
        end
    end
end

-- Keybind label visibility
local function ApplyKeybindVisibility()
    local saved = sui.saved
    if not saved then return end

    local alpha = saved.keybindsVisible and 1 or 0
    local hidden = not saved.keybindsVisible

    for i = 3, 8 do
        local label = _G["ActionButton"..i.."ButtonText"]
        if label then
            label:SetAlpha(alpha)
            label:SetHidden(hidden)
        end
    end

    local extras = { "QuickslotButtonButtonText", "CompanionUltimateButtonButtonText" }
    for _, name in ipairs(extras) do
        local label = _G[name]
        if label then
            label:SetAlpha(alpha)
            label:SetHidden(hidden)
        end
    end
end

-- Weapon swap button visibility
local function ApplyWeaponSwapVisibility()
    local saved = sui.saved
    if not saved then return end

    local button = ZO_ActionBar1WeaponSwap
    if button then
        button:SetAlpha(saved.weaponSwapVisible and 1 or 0)
    end
end

-- Hook into ESO's template application so our changes survive reloads
SecurePostHook("ApplyTemplateToControl", function(control, template)
    if template:find("ZO_ActionButton") then
        ApplySUIActionBarTemplates()
        ApplyUltimateTemplate()
    end
end)

-- Public function to apply all settings
function sui.applyActionBarSettings()
    ApplyWeaponSwapVisibility()
    ApplyKeybindVisibility()
    ApplyUltimateTemplate()
end

-- Initialize and apply on load
function sui.initializeActionBar()
    sui.applyActionBarSettings()
end
