--------------------------------------------------
-- ShibUI Group Unit Frame Module
--------------------------------------------------
local GROUP_UNIT_FRAME = "ZO_GroupUnitFrame"
local COMPANION_UNIT_FRAME = "ZO_CompanionUnitFrame"
local COMPANION_GROUP_UNIT_FRAME = "ZO_CompanionGroupUnitFrame"

SecurePostHook("CreateControlFromVirtual", function(name, _, template, suffix)
    if template == GROUP_UNIT_FRAME or template == COMPANION_UNIT_FRAME or template == COMPANION_GROUP_UNIT_FRAME then
        local control = GetControl(name, suffix)
        local newTemplate = string.gsub(template, "ZO_", "SUI_")
        ApplyTemplateToControl(control, newTemplate)
    end
end)

SecurePostHook(ZO_UnitFrameObject, "ApplyVisualStyle", function(self)
    if (self.style == GROUP_UNIT_FRAME or self.style == COMPANION_UNIT_FRAME or self.style == COMPANION_GROUP_UNIT_FRAME) and self.healthBar and self.healthBar.barControls then
        for i = 1, #self.healthBar.barControls do
            self.healthBar.barControls[i]:SetHeight(18)
        end
    end
end)