--------------------------------------------------
-- ShibUI Debugging Module
--------------------------------------------------
local SUI = SUI

SUI.Debug = SUI.Debug or {}
local Debug = SUI.Debug

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
    d(string.format("%s[ShibUI]|r %s[%s]|r %s%s|r", colorAddon, colorSource, "General", colorMessage, "Debug called with no arguments."))
    d(debug.traceback())
end

--------------------------------------------------
-- Debugging function for ShibUI
-- Usage: SUI.Debug:Log("Source", "Message", optionalDelayInMs)
-- Define local Log = function(...) SUI.Debug:Log(...) end for easier access.
-- Only logs if debug mode is enabled in settings.
--------------------------------------------------
function Debug:Log(source, message, delay)
    if not (SUI.SavedVars.saved and SUI.SavedVars.saved.debug) then return end
    -- Check for missing arguments
    if source == nil and message == nil then
        DebugWarnNoArgs()
        return
    end
    -- Handle single string argument
    if message == nil and type(source) == "string" then
        message = source
        source = "General"
    end
    -- If no delay is provided, default to 2000ms
    local delayMs = delay or 2000
    zo_callLater(function()
        d(FormatDebugMessage(source, message))
    end, delayMs)
end