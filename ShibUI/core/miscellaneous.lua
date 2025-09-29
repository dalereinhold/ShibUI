--------------------------------------------------
-- ShibUI Miscellaneous Module
--------------------------------------------------
ShibUI.Miscellaneous = ShibUI.Miscellaneous or {}
local Miscellaneous = ShibUI.Miscellaneous
local sui = ShibUI

--------------------------------------------------
-- Apply miscellaneous textures to blank textures.
--------------------------------------------------
local blankTexture = "/esoui/art/icons/heraldrycrests_misc_blank_01.dds"
local RedirectTexture = RedirectTexture

function Miscellaneous:Initialize()
    RedirectTexture("/esoui/art/itemtooltip/item_chargemeter.dds", blankTexture)
    RedirectTexture("/esoui/art/performance/statusmetermunge.dds", blankTexture)
end