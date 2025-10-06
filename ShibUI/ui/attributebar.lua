--------------------------------------------------
-- ShibUI Attribute Bar Module
--------------------------------------------------
local SUI = SUI
local sv

SUI.AttributeBar = SUI.AttributeBar or {}
local AttributeBar = SUI.AttributeBar

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
end

local function DefaultTextures()
    for _, tex in ipairs(defaultTextures) do
        RedirectTexture(tex, tex)
    end
end

---------------------------------------------------
-- Attribute Bar size and layout control
---------------------------------------------------
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
        barSizeNormal = true
    end
end

local function SetBarSizeToDefault()
    for _, bar in ipairs(bars) do
        -- Reset to ESO's default dynamic behavior
        UnlockBarWidth(bar)
    end
    if not barSizeDefault then
        barSizeDefault = true
    end
end

local function SetBarSizeToExpanded()
    for _, bar in ipairs(bars) do
        LockBarWidth(bar, expandedWidth)
    end
    if not barSizeExpanded then
        barSizeExpanded = true
    end
end

-- Event handler to keep bar width locked live
local function OnAttributeBarRelevantUpdate()
    if sv and sv.attributeBar then
        if sv then
            SUI.ApplyAttributeBarSize(sv.attributeBarSize)
        else
            SUI.ApplyAttributeBarSize("default")
        end
    end
end

function SUI.ApplyAttributeBarSize(mode)
    ResetBarSizeFlags()
    if mode == "default" then
        -- Unregister events so bars can resize dynamically
        EVENT_MANAGER:UnregisterForEvent("ShibUI_AttributeBarLock_Stats", EVENT_STATS_UPDATED)
        EVENT_MANAGER:UnregisterForEvent("ShibUI_AttributeBarLock_Power", EVENT_POWER_UPDATE)
        SetBarSizeToDefault()
    elseif mode == "normal" or mode == "expanded" then
        -- Register events to keep width locked
        EVENT_MANAGER:RegisterForEvent("ShibUI_AttributeBarLock_Stats", EVENT_STATS_UPDATED, OnAttributeBarRelevantUpdate)
        EVENT_MANAGER:RegisterForEvent("ShibUI_AttributeBarLock_Power", EVENT_POWER_UPDATE, function(_, unitTag)
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
    end
end

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
        barLayoutPyramid = true
    end
end

local function SetLayoutShibui()
    ClearAllBarAnchors()

    hpBar:SetAnchor(BOTTOM, GuiRoot, BOTTOM, 0, -94)
    mpBar:SetAnchor(BOTTOMRIGHT, GuiRoot, BOTTOM, -200, -94)
    spBar:SetAnchor(BOTTOMLEFT, GuiRoot, BOTTOM, 200, -94)

    if not barLayoutShibui then
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
        barLayoutDefault = true
    end
end

function SUI.ApplyAttributeBarLayout(layout)
        if layout == "pyramid" then
            SetLayoutPyramid()
        elseif layout == "shibui" then
            SetLayoutShibui()
        elseif layout == "default" then
            SetLayoutDefault()
        else
    end
end

---------------------------------------------------
-- Apply Attribute Bar Settings
---------------------------------------------------
function AttributeBar:Initialize()
    sv = SUI.SavedVars.saved
    if sv and sv.attributeBar then
        BlankTextures()
        local layout = sv.attributeBarPyramid and "pyramid" or "shibui"
        SUI.ApplyAttributeBarLayout(layout)
    else
        DefaultTextures()
        SUI.ApplyAttributeBarLayout("default")
    end
    SUI.ApplyAttributeBarSize(sv.attributeBarSize)
        EVENT_MANAGER:UnregisterForEvent("ShibUI_AttributeBarWidth", EVENT_STATS_UPDATED)
    local layout = sv.attributeBarPyramid and "pyramid" or "shibui"
    SUI.ApplyAttributeBarLayout(layout)

    EVENT_MANAGER:RegisterForEvent("ShibUI_AttributeBarWidth", EVENT_STATS_UPDATED, function()
        local layout = sv.attributeBarPyramid and "pyramid" or "shibui"
        SUI.ApplyAttributeBarLayout(layout)
    end)
end