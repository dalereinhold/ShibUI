--------------------------------------------------
-- ShibUI Attribute Bar Module
--------------------------------------------------

local sui = ShibUI

---------------------------------------------------
-- Texture Redirection for Attribute Bar
---------------------------------------------------
local blankTexture = "/esoui/art/icons/heraldrycrests_misc_blank_01.dds"
local basePath = "/esoui/art/unitattributevisualizer/"

local defaultTextures = {
    basePath .. "attributebar_dynamic_bg.dds",
    basePath .. "attributebar_dynamic_frame.dds",
    basePath .. "attributebar_dynamic_increasedarmor_bg.dds",
    basePath .. "attributebar_dynamic_increasedarmor_frame.dds",
    basePath .. "attributebar_small_base_center.dds",
    basePath .. "attributebar_small_base.dds",
    basePath .. "attributebar_small_frame_center.dds",
    basePath .. "attributebar_small_frame.dds",
}

local function BlankTextures()
    for _, tex in ipairs(defaultTextures) do
        RedirectTexture(tex, blankTexture)
    end
    sui.debug("Attribute Bar", "Textures removed.")
end

local function DefaultTextures()
    for _, tex in ipairs(defaultTextures) do
        RedirectTexture(tex, tex)
    end
    sui.debug("Attribute Bar", "Default textures restored.")
end
-- end of texture control

---------------------------------------------------
-- Attribute Bar size and layout control
---------------------------------------------------
local em = EVENT_MANAGER
local eventStatsUpdated = EVENT_STATS_UPDATED
local eventPowerUpdate = EVENT_POWER_UPDATE

local shrunkWidth = 141 -- ESO default values
local normalWidth = 237 -- ESO default values
local expandedWidth = 323 -- ESO default values

local pBar = ZO_PlayerAttribute
local hpBar = ZO_PlayerAttributeHealth
local mpBar = ZO_PlayerAttributeMagicka
local spBar = ZO_PlayerAttributeStamina

local bars = { hpBar, mpBar, spBar }

local function LockBarWidth(bar, width)
    bar:SetWidth(width)
end

local function UnlockBarWidth(bar)
    -- Do nothing; let ESO handle the width dynamically
end

local barSizeNormal = false
local barSizeDefault = false
local barSizeExpanded = false

local function ResetBarSizeFlags()
    barSizeNormal = false
    barSizeDefault = false
    barSizeExpanded = false
end

local function SetBarSizeToNormal()
    for _, bar in ipairs(bars) do
        LockBarWidth(bar, normalWidth)
    end
    if not barSizeNormal then
        sui.debug("Attribute Bar", "Locked bar width to normal size.")
        barSizeNormal = true
    end
end

--[[local POWERTYPE_HEALTH = 1
local POWERTYPE_MAGICKA = 2
local POWERTYPE_STAMINA = 6

local function GetExpectedBarWidth(powertype)
    local maxPower = GetUnitPowerMax("player", powertype)
    -- Use a threshold to decide between normal and expanded
    if maxPower > 20000 then -- Adjust threshold as needed for your use case
        return expandedWidth
    else
        return normalWidth
    end
end]]

local function SetBarSizeToDefault()
    -- hpBar:SetWidth(GetExpectedBarWidth(POWERTYPE_HEALTH))
    -- mpBar:SetWidth(GetExpectedBarWidth(POWERTYPE_MAGICKA))
    -- spBar:SetWidth(GetExpectedBarWidth(POWERTYPE_STAMINA))
    for _, bar in ipairs(bars) do
        -- Reset to ESO's default dynamic behavior
        UnlockBarWidth(bar)
    end
    if not barSizeDefault then
        sui.debug("Attribute Bar", "Unlocked bar width to default size (auto-adjusted).")
        barSizeDefault = true
    end
end

local function SetBarSizeToExpanded()
    for _, bar in ipairs(bars) do
        LockBarWidth(bar, expandedWidth)
    end
    if not barSizeExpanded then
        sui.debug("Attribute Bar", "Locked bar width to expanded size.")
        barSizeExpanded = true
    end
end

-- Event handler to keep bar width locked live
local function OnAttributeBarRelevantUpdate()
    if sui.saved and sui.saved.attributeBar then
        sui.applyAttributeBarSize(sui.saved.attributeBarSize)
    end
end

function sui.applyAttributeBarSize(mode)
    ResetBarSizeFlags()
    if mode == "default" then
        -- Unregister events so bars can resize dynamically
        em:UnregisterForEvent("ShibUI_AttributeBarLock_Stats", eventStatsUpdated)
        em:UnregisterForEvent("ShibUI_AttributeBarLock_Power", eventPowerUpdate)
        SetBarSizeToDefault()
    elseif mode == "normal" or mode == "expanded" then
        -- Register events to keep width locked
        em:RegisterForEvent("ShibUI_AttributeBarLock_Stats", eventStatsUpdated, OnAttributeBarRelevantUpdate)
        em:RegisterForEvent("ShibUI_AttributeBarLock_Power", eventPowerUpdate, function(_, unitTag)
            if unitTag == "player" then
                OnAttributeBarRelevantUpdate()
            end
        end)
        if mode == "normal" then
            SetBarSizeToNormal()
        else
            SetBarSizeToExpanded()
        end
    else
        sui.debug("Attribute Bar", "Unknown width mode: " .. tostring(mode))
    end
end
-- end of bar size control

local barLayoutPyramid = false
local barLayoutShibui = false
local barLayoutDefault = false

local function ClearAllBarAnchors()
    for _, bar in ipairs(bars) do
        bar:ClearAnchors()
    end
end

local function SetLayoutPyramid()
    ClearAllBarAnchors()

    hpBar:SetAnchor(BOTTOM, GuiRoot, BOTTOM, 0, -115)
    mpBar:SetAnchor(BOTTOMRIGHT, GuiRoot, BOTTOM, -5, -90)
    spBar:SetAnchor(BOTTOMLEFT, GuiRoot, BOTTOM, 5, -90)

    if not barLayoutPyramid then
        sui.debug("Attribute Bar", "Set layout to pyramid.")
        barLayoutPyramid = true
    end
end

local function SetLayoutShibui()
    ClearAllBarAnchors()

    hpBar:SetAnchor(BOTTOM, GuiRoot, BOTTOM, 0, -94)
    mpBar:SetAnchor(BOTTOMRIGHT, GuiRoot, BOTTOM, -200, -94)
    spBar:SetAnchor(BOTTOMLEFT, GuiRoot, BOTTOM, 200, -94)

    if not barLayoutShibui then
        sui.debug("Attribute Bar", "Set layout to shibui.")
        barLayoutShibui = true
    end
end

local function SetLayoutDefault()
    ClearAllBarAnchors()

    hpBar:SetAnchor(CENTER, pBar, CENTER, 0, 0)
    mpBar:SetAnchor(RIGHT, pBar, LEFT, 237, 0)
    spBar:SetAnchor(LEFT, pBar, RIGHT, -237, 0)

    pBar:ClearAnchors()
    pBar:SetAnchor(BOTTOM, GuiRoot, BOTTOM, 0, -74)

    if not barLayoutDefault then
        sui.debug("Attribute Bar", "Set layout to default.")
        barLayoutDefault = true
    end
end

function sui.applyAttributeBarLayout(layout)
    if layout == "pyramid" then
        SetLayoutPyramid()
    elseif layout == "shibui" then
        SetLayoutShibui()
    elseif layout == "default" then
        SetLayoutDefault()
    else
        sui.debug("Attribute Bar", "Unknown layout: " .. tostring(layout))
    end
end
-- end of layout control

---------------------------------------------------
-- Apply Attribute Bar Settings
---------------------------------------------------
function sui.initializeAttributeBar()
    if sui.saved and sui.saved.attributeBar then
        BlankTextures()
        local layout = sui.saved.attributeBarPyramid and "pyramid" or "shibui"
        sui.applyAttributeBarLayout(layout)
    else
        DefaultTextures()
        sui.applyAttributeBarLayout("default")
    end
    sui.applyAttributeBarSize(sui.saved.attributeBarSize)
end
-- end of apply attribute bar settings