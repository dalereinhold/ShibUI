-----------------------------------------------------------
-- ShibUI Compass Modifications
-----------------------------------------------------------

ApplyTemplateToControl(ZO_CompassFrame, 'SUI_CompassFrame')
ApplyTemplateToControl(ZO_Compass,      'SUI_Compass')
ApplyTemplateToControl(ZO_BossBar,      'SUI_BossBar')

-- Don't Resize Compass
ZO_CompassFrame:UnregisterForEvent(EVENT_PLAYER_ACTIVATED)
ZO_CompassFrame:UnregisterForEvent(EVENT_SCREEN_RESIZED)

-- Don't Resize Compass Height
function COMPASS_FRAME:SetBossBarActive (active)
  self.bossBarActive = active
  self:RefreshVisible()
end

-- Change Compass Quest Area Opacity
-- ingame / compass / compassframe.lua
do local Original = Compass.ApplyTemplateToControlToAreaTexture
  function Compass:ApplyTemplateToControlToAreaTexture(texture, template, restingAlpha, pinType)
    return Original(self, texture, template, 0.5, pinType) -- Set to 50%
  end
end