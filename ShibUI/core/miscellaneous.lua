--------------------------------------------------
-- ShibUI Miscellaneous Module
--------------------------------------------------
local SUI = SUI
local sv

SUI.Miscellaneous = SUI.Miscellaneous or {}
local Miscellaneous = SUI.Miscellaneous

local Log = function(...) SUI.Debug:Log(...) end

--------------------------------------------------
-- Apply miscellaneous textures to blank textures.
--------------------------------------------------
local blankTexture = "/esoui/art/icons/heraldrycrests_misc_blank_01.dds"
local RedirectTexture = RedirectTexture

function Miscellaneous:Initialize()
    sv = SUI.SavedVars.saved
    
    RedirectTexture("/esoui/art/chatwindow/chat_minimized_mungebg.dds", blankTexture)
    RedirectTexture("/esoui/art/chatwindow/chat_bg_edge.dds", blankTexture)
    RedirectTexture("/esoui/art/chatwindow/chat_bg_center.dds", blankTexture)
    RedirectTexture("/esoui/art/itemtooltip/item_chargemeter.dds", blankTexture)
    RedirectTexture("/esoui/art/performance/statusmetermunge.dds", blankTexture)
    
    Log("Miscellaneous", "Initialized")
end