--------------------------------------------------
-- ShibUI Player Progress Bar Template
--------------------------------------------------
SecurePostHook(PLAYER_PROGRESS_BAR, "RefreshTemplate", function(self)
    ApplyTemplateToControl(self.barControl, "SUI_PlayerProgressBarTemplate")
end)