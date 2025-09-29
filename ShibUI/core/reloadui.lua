--------------------------------------------------
-- ShibUI Reload UI Module (OOP Refactor)
--------------------------------------------------

ShibUI.ReloadUI = ShibUI.ReloadUI or {}
local ReloadUI = ShibUI.ReloadUI
local sui = ShibUI

--------------------------------------------------
-- Helper Functions for Reload UI
--------------------------------------------------
local function RegisterDialogs()
    ZO_Dialogs_RegisterCustomDialog("RELOADUI_CONFIRM_DIALOG", {
        title = { text = "Reload UI" },
        mainText = { text = "Are you sure you want to reload the UI?" },
        buttons = {
            {
                text = SI_DIALOG_ACCEPT,
                callback = function()
                    _G.ReloadUI()
                end,
            },
            {
                text = SI_DIALOG_CANCEL,
            },
        },
    })
end

--------------------------------------------------
-- Reload UI Functionality
--------------------------------------------------
local function PerformReload()
    if sui.saved and sui.saved.confirmReload then
        ZO_Dialogs_ShowDialog("RELOADUI_CONFIRM_DIALOG")
    else
        _G.ReloadUI()
    end
end

function ReloadUIOnKeybind()
    PerformReload()
end


--------------------------------------------------
-- Initialize Reload UI Module
--------------------------------------------------
function ReloadUI:Initialize()
    RegisterDialogs()
    ZO_CreateStringId("SI_BINDING_NAME_RELOAD_UI_KEYBIND", "Reload UI")
    SLASH_COMMANDS["/sui"] = function() PerformReload() end
end