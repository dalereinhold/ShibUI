-----------------------------------------------------------
-- ShibUI Compass/Boss Bar Module
-----------------------------------------------------------
ApplyTemplateToControl(ZO_CompassFrame, "SUI_CompassFrame")
ApplyTemplateToControl(ZO_Compass,      "SUI_Compass")
ApplyTemplateToControl(ZO_BossBar,      "SUI_BossBar")

-- Don't Resize Compass
ZO_CompassFrame:UnregisterForEvent(EVENT_PLAYER_ACTIVATED)
ZO_CompassFrame:UnregisterForEvent(EVENT_SCREEN_RESIZED)

-- Don't Resize Compass Height
function COMPASS_FRAME:SetBossBarActive (active)
  self.bossBarActive = active
  self:RefreshVisible()
end