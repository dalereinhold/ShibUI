--------------------------------------------------
-- ShibUI Action Bar Module
--------------------------------------------------

-- Apply the bar template
ApplyTemplateToControl(ZO_ActionBar1, "SUI_ActionBar1")

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
--------------------------------------------------
-- Override animation style method to maintain custom sizing
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

local function DisableUltimateLeadingEdge()
    local ultimateButtons = {
        _G["ActionButton8"],           -- Player Ultimate
        _G["CompanionUltimateButton"]  -- Companion Ultimate
    }

    for _, ultimate in ipairs(ultimateButtons) do
        if ultimate then
            local leadingEdge = ultimate:GetNamedChild("LeadingEdge")
            if leadingEdge then
                leadingEdge:SetHidden(true)
                leadingEdge.SetHidden = function() end    -- neutralize future show/hide
                leadingEdge.ClearAnchors = function() end -- block ESO re-anchoring it
                leadingEdge.SetAnchor = function() end    -- block re-anchoring too
            end
        end
    end
end

EVENT_MANAGER:RegisterForEvent("ShibUI_DisableLeadingEdge", EVENT_PLAYER_ACTIVATED, DisableUltimateLeadingEdge)