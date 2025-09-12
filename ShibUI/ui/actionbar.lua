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
        if self.slot == _G["ActionButton8"] then
            -- Ultimate button
            ApplyTemplateToControl(self.slot, 'SUI_UltimateActionButton_Keyboard_Template')
        else
            -- Normal buttons
            ApplyTemplateToControl(self.slot, 'SUI_ActionButton_Keyboard_Template')
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
    end, 380) -- 380ms seems to work well
end

-- Register events
EVENT_MANAGER:RegisterForEvent("ShibUI_ActionBarSwap", EVENT_ACTION_SLOTS_FULL_UPDATE, ApplyUltimateAfterSwap)

--------------------------------------------------
-- Initialize
--------------------------------------------------
function ActionBar:Initialize()
    ApplyActionBarTemplates()
end
