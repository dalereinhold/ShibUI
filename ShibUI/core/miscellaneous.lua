--------------------------------------------------
-- ShibUI Miscellaneous Module
--------------------------------------------------
local SUI = SUI
local sv

SUI.Miscellaneous = SUI.Miscellaneous or {}
local Miscellaneous = SUI.Miscellaneous

--------------------------------------------------
-- Apply miscellaneous textures to blank textures.
--------------------------------------------------
local blankTexture = "/esoui/art/icons/heraldrycrests_misc_blank_01.dds"
local RedirectTexture = RedirectTexture

function Miscellaneous:Initialize()
    sv = SUI.saved
    
    RedirectTexture("/esoui/art/itemtooltip/item_chargemeter.dds", blankTexture)
    RedirectTexture("/esoui/art/performance/statusmetermunge.dds", blankTexture)
end