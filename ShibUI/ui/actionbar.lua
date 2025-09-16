--------------------------------------------------
-- ShibUI Action Bar Module
--------------------------------------------------
ShibUI.ActionBar = ShibUI.ActionBar or {}

local ActionBar = ShibUI.ActionBar
local sui = ShibUI

--------------------------------------------------
-- Apply Templates
--------------------------------------------------
local function ApplyActionBarTemplates()
    if not sui.saved.enableActionBar then return end

    -- Apply the bar template
    ApplyTemplateToControl(ZO_ActionBar1, 'SUI_ActionBar1')

    -- Hook all buttons
    SecurePostHook(ActionButton, 'ApplyStyle', function(self)
        if self.slot == _G["ActionButton8"] or self.slot == _G["CompanionUltimateButton"] then
            ApplyTemplateToControl(self.slot, 'SUI_UltimateActionButton_Keyboard_Template')
        else
            ApplyTemplateToControl(self.slot, 'SUI_ActionButton_Keyboard_Template')
        end
    end)
    
    -- Hook the backbar timer
    SecurePostHook(ZO_ActionBarTimer, 'ApplyStyle', function(self)
        ApplyTemplateToControl(self.slot, 'SUI_ActionBarTimer_BackBarSlot_Keyboard_Template')
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
end

--------------------------------------------------
-- Handle Ultimate Button After Swap
--------------------------------------------------
local function ApplyUltimateAfterSwap()
    -- Delay ensures ESO finishes internal ApplyStyle and sub-control resets
    zo_callLater(function()
        local ultimate = _G["ActionButton8"]
        if ultimate then
            ApplyTemplateToControl(ultimate, 'SUI_UltimateActionButton_Keyboard_Template')
        end
    end, 400)
end

-- Register events
EVENT_MANAGER:RegisterForEvent("ShibUI_ActionBarSwap", EVENT_ACTION_SLOTS_FULL_UPDATE, ApplyUltimateAfterSwap)

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

--------------------------------------------------
-- Initialize
--------------------------------------------------
function ActionBar:Initialize()
    ApplyActionBarTemplates()
end
