--------------------------------------------------
-- ShibUI Compass/BossBar Module
--------------------------------------------------

local sui = ShibUI

---------------------------------------------------
-- Texture Redirection for Compass and BossBar
---------------------------------------------------
local blankTexture = "/esoui/art/icons/heraldrycrests_misc_blank_01.dds"
local basePath = "/esoui/art/"

local defaultTextures = {
    basePath .. "bossbar/bossbar_bracket_left.dds",
    basePath .. "bossbar/bossbar_bracket_right.dds",
    basePath .. "compass/compass.dds",
    basePath .. "compass/compass_frame.dds",
    basePath .. "tooltips/munge_overlay.dds"
}

local function BlankTextures()
    for _, tex in ipairs(defaultTextures) do
        RedirectTexture(tex, blankTexture)
    end
    sui.debug("Compass/BossBar", "Textures removed.")
end

local function DefaultTextures()
    for _, tex in ipairs(defaultTextures) do
        RedirectTexture(tex, tex)
    end
    sui.debug("Compass/BossBar", "Default textures restored.")
end
-- end of texture control

---------------------------------------------------
-- Apply Compass/BossBar Settings
---------------------------------------------------
function sui.initializeCompass()
    if sui.saved and sui.saved.compass then
        BlankTextures()
    else
        DefaultTextures()
    end
end
-- end of apply compass settings