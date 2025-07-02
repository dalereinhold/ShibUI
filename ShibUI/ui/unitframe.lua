--------------------------------------------------
-- ShibUI Unit Frame Module
--------------------------------------------------

local sui = ShibUI

--------------------------------------------------
-- Texture Redirection for Unit Frames
--------------------------------------------------
local blankTexture = "/esoui/art/icons/heraldrycrests_misc_blank_01.dds"
local basePath = "/esoui/art/unitframes/"

local defaultTextures = { 
    basePath .. "unitframe_group_left.dds",
    basePath .. "unitframe_group_right.dds",
    basePath .. "unitframe_group_withcompanion.dds",
    basePath .. "target_health_frame.dds",
}

local function BlankTextures()
    for _, tex in ipairs(defaultTextures) do
        RedirectTexture(tex, blankTexture)
    end
    sui.debug("Unit Frame", "Textures removed.")
end

local function DefaultTextures()
    for _, tex in ipairs(defaultTextures) do
        RedirectTexture(tex, tex)
    end
    sui.debug("Unit Frame", "Default textures restored.")
end
-- end of texture control

--------------------------------------------------
-- Apply Unit Frame Settings
--------------------------------------------------
function sui.initializeUnitFrame()
    if sui.saved and sui.saved.unitFrame then
        BlankTextures()
    else
        DefaultTextures()
    end
end
-- end of apply unit frame settings