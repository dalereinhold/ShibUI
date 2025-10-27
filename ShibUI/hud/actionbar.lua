--------------------------------------------------
-- ShibUI Action Bar Module
--------------------------------------------------
local SUI = SUI
local sv

SUI.ActionBar = SUI.ActionBar or {}
local ActionBar = SUI.ActionBar

local Log = function(...) SUI.Debug:Log("Action Bar", ...) end

-- Apply the bar template
ApplyTemplateToControl(ZO_ActionBar1, "SUI_ActionBar1")

function ActionBar:ApplyWeaponSwapVisibility()
    ZO_ActionBar1WeaponSwap:SetAlpha(sv.showWeaponSwap and 1 or 0)
end

function ActionBar:ToggleWeaponSwap()
    sv.showWeaponSwap = not sv.showWeaponSwap
    self:ApplyWeaponSwapVisibility()
    Log("Weapon Swap Icon: " .. (sv.showWeaponSwap and "ON" or "OFF"), 0)
end

function ActionBar:ToggleKeybindings()
    sv.showKeybindings = not sv.showKeybindings

    -- hide/show each action button's text
    for i = 1, 8 do
        local buttonText = _G["ActionButton"..i.."ButtonText"]
        if buttonText and buttonText.SetHidden then
            buttonText:SetHidden(not sv.showKeybindings)
        end
    end

    -- quickslot text
    local quickslotText = _G["QuickslotButtonButtonText"]
    if quickslotText and quickslotText.SetHidden then
        quickslotText:SetHidden(not sv.showKeybindings)
    end

    -- ultimate button text
    local ultimateText = _G["CompanionUltimateButtonButtonText"]
    if ultimateText and ultimateText.SetHidden then
        ultimateText:SetHidden(not sv.showKeybindings)
    end

    Log("Action Bar Keybindings: " .. (sv.showKeybindings and "ON" or "OFF"), 0)
end

-- Hook all buttons
SecurePostHook(ActionButton, "ApplyStyle", function(self)
    if self.slot == _G["ActionButton8"] or self.slot == _G["CompanionUltimateButton"] then
        ApplyTemplateToControl(self.slot, "SUI_UltimateActionButton_Keyboard_Template")
        -- Ensure FlipCard maintains correct size
        zo_callLater(function()
            if self.flipCard then
                self.flipCard:SetDimensions(57, 57)
            end
        end, 50)
    else
        ApplyTemplateToControl(self.slot, "SUI_ActionButton_Keyboard_Template")
    end
end)

-- Hook the backbar timer
SecurePostHook(ZO_ActionBarTimer, "ApplyStyle", function(self)
    ApplyTemplateToControl(self.slot, "SUI_ActionBarTimer_BackBarSlot_Keyboard_Template")
end)

-- Hook the buff/debuff icons
SecurePostHook("CreateControlFromVirtual", function(name, parent, template, suffix)
    if template == "ZO_BuffDebuffIcon" then
        local control = GetControl(name, suffix)
        if control then
            ApplyTemplateToControl(control, "SUI_BuffDebuffIcon")
        end
    end
end)

--------------------------------------------------
-- Handle Ultimate Button After Swap
-- Override animation style method to maintain custom sizing
--------------------------------------------------
local originalApplySwapAnimationStyle = ActionButton.ApplySwapAnimationStyle
function ActionButton:ApplySwapAnimationStyle()
    originalApplySwapAnimationStyle(self)
    
    if self.slot == _G["ActionButton8"] then
        self.flipCard:SetDimensions(57, 57)
        local timeline = self.hotbarSwapAnimation
        if timeline then
            local firstAnimation = timeline:GetFirstAnimation()
            local lastAnimation = timeline:GetLastAnimation()
            firstAnimation:SetStartAndEndWidth(57, 57)
            firstAnimation:SetStartAndEndHeight(57, 0)
            lastAnimation:SetStartAndEndWidth(57, 57)
            lastAnimation:SetStartAndEndHeight(0, 57)
        end
    end
end

function ActionBar:Initialize()
    sv = SUI.SavedVars.saved
    self:ApplyWeaponSwapVisibility()
    self:ToggleKeybindings()
    Log("Initialized")
end