--------------------------------------------------
-- ShibUI Reload UI Module
--------------------------------------------------

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
                    ReloadUI()
                end,
            },
            {
                text = SI_DIALOG_CANCEL,
            },
        },
    })
end
-- end of helper functions

--------------------------------------------------
-- Reload UI Functionality
--------------------------------------------------
function sui.performReload()
    if sui.saved and sui.saved.confirmReload then
        ZO_Dialogs_ShowDialog("RELOADUI_CONFIRM_DIALOG")
    else
        ReloadUI()
    end
end

function ReloadUI_OnKeybind()
    sui.performReload()
end
-- end of Reload UI functionality

--------------------------------------------------
-- Initialize Reload UI Module
--------------------------------------------------
function sui.initializeReloadUI()
    RegisterDialogs()
    ZO_CreateStringId("SI_BINDING_NAME_RELOAD_UI_KEYBIND", "Reload UI")
    SLASH_COMMANDS["/sui"] = sui.performReload
end
