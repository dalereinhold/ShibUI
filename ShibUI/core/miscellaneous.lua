--------------------------------------------------
-- ShibUI Miscellaneous Module
--------------------------------------------------

local sui = ShibUI

--------------------------------------------------
-- Apply miscellaneous textures to blank textures.
--------------------------------------------------
local blankTexture = "/esoui/art/icons/heraldrycrests_misc_blank_01.dds"
local RedirectTexture = RedirectTexture

function sui.initializeMiscellaneous()
    RedirectTexture("/esoui/art/miscellaneous/progressbar_frame.dds", blankTexture)
    RedirectTexture("/esoui/art/miscellaneous/progressbar_frame_bg.dds", blankTexture)
    RedirectTexture("/esoui/art/itemtooltip/item_chargemeter.dds", blankTexture)
    RedirectTexture("/esoui/art/performance/statusmetermunge.dds", blankTexture)
    sui.debug("Miscellaneous", "Textures removed.")
end
-- end of apply miscellaneous textures