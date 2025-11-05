--------------------------------------------------
-- ShibUI Chat Window Module
--------------------------------------------------
local SUI = SUI
local sv

SUI.ChatWindow = SUI.ChatWindow or {}
local ChatWindow = SUI.ChatWindow

local Log = function(...) SUI.Debug:Log("Chat Window", ...) end

-- Chat Window Size Controls
function ChatWindow:SetSize()
    if sv and ZO_ChatWindow then
        ZO_ChatWindow:SetDimensions(sv.chatWidth, sv.chatHeight)
    end
end

-- Chat Window Position Controls
function ChatWindow:SetPosition()
    if sv and ZO_ChatWindow then
        ZO_ChatWindow:ClearAnchors()

        local horizAnchor = (sv.chatSide == "Left") and LEFT or RIGHT
        local vertAnchor = (sv.chatAnchor == "Top") and TOP or BOTTOM
        
        -- Always add padding to prevent chat from touching screen edges
        local xOffset = 0
        local yOffset = 0
        
        if sv.chatAnchor == "Bottom" then
            yOffset = -82  -- Bottom padding (matches ESO default to avoid UI overlap)
        elseif sv.chatAnchor == "Top" then
            yOffset = 50   -- Top padding for better visibility and header clearance
        end

        ZO_ChatWindow:SetAnchor(vertAnchor + horizAnchor, GuiRoot, vertAnchor + horizAnchor, xOffset, yOffset)
    end
end

-- Set default chat channel without opening chat input
local function SetDefaultChatChannel()
    if sv and sv.chatDefaultChannel and CHAT_ROUTER then
        -- Set the default channel without opening the chat input
        local chatSystem = ZO_GetChatSystem()
        if chatSystem then
            chatSystem:SetChannel(sv.chatDefaultChannel)
        end
    end
end

--------------------------------------------------
function ChatWindow:Initialize()
    sv = SUI.SavedVars.saved
    
    -- Apply initial settings
    self:SetSize()
    self:SetPosition()
    
    -- Register the event handler after sv is initialized
    -- Only set default channel once per session, not on every player activation
    local hasSetDefaultChannel = false
    local function OnPlayerActivated()
        if not hasSetDefaultChannel then
            SetDefaultChatChannel()
            hasSetDefaultChannel = true
        end
    end
    
    EVENT_MANAGER:RegisterForEvent("ShibUI_ChatWindow", EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
    
    Log("Initialized")
end