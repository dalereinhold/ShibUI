--------------------------------------------------
-- ShibUI Debugging Module
--------------------------------------------------

local sui = ShibUI

--------------------------------------------------
-- Private helpers
--------------------------------------------------
local colorAddon   = "|cFF9900"   -- Orange for addon name
local colorSource  = "|c80FFBF"   -- Light Green for source
local colorMessage = "|cF0F0F0"   -- Light Gray for message

local function FormatDebugMessage(source, message)
    local src = tostring(source or "General")
    local msg = message ~= nil and tostring(message) or ""

    if msg == "" then
        return string.format("%s[ShibUI]|r %s[%s]|r", colorAddon, colorSource, src)
    else
        return string.format("%s[ShibUI]|r %s[%s]|r %s%s|r", colorAddon, colorSource, src, colorMessage, msg)
    end
end

local function DebugWarnNoArgs()
    d(string.format("%s[ShibUI]|r %s[%s]|r %s%s|r", colorAddon, colorSource, "General", colorMessage, "sui.debug called with no arguments."))
    d(debug.traceback())
end
-- end of private helpers

--------------------------------------------------
-- Debugging function for ShibUI
--------------------------------------------------
function sui.debug(source, message, delay)
    if not (sui.saved and sui.saved.debug) then return end

    if source == nil and message == nil then
        DebugWarnNoArgs()
        return
    end

    if message == nil and type(source) == "string" then
        message = source
        source = "General"
    end

    local delayMs = delay or 2000

    zo_callLater(function()
        d(FormatDebugMessage(source, message))
    end, delayMs)
end
