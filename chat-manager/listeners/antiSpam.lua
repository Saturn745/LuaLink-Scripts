local config = require("config")

-- Storage table
local playerMessages = {}

-- Function to clean up old messages
local function cleanupOldMessages()
    local currentTime = os.time()
    for player, data in pairs(playerMessages) do
        -- Remove messages older than the time window
        local i = 1
        while i <= #data.messages do
            if currentTime - data.messages[i] > config.antiSpam.timeWindow then
                table.remove(data.messages, i)
            else
                i = i + 1
            end
        end

        -- Remove player from tracking if no recent messages and not on cooldown
        if #data.messages == 0 and (not data.cooldownUntil or data.cooldownUntil < currentTime) then
            playerMessages[player] = nil
        end
    end
end

script:registerListener("io.papermc.paper.event.player.AsyncChatEvent", function(event)
    ---@cast event io.papermc.paper.event.player.AsyncChatEvent
    local player = event:getPlayer()
    local playerName = player:getName()
    local currentTime = os.time()
    local message = event:signedMessage():message()

    -- Initialize player data if not exists
    if not playerMessages[playerName] then
        playerMessages[playerName] = {
            messages = {},
            lastMessage = nil,
            cooldownUntil = nil
        }
    end

    local playerData = playerMessages[playerName]

    -- Check if player is on cooldown
    if playerData.cooldownUntil and currentTime < playerData.cooldownUntil then
        player:sendRichMessage(config.antiSpam.blockMessage)
        event:setCancelled(true)
        return
    end

    -- Check for duplicate or similar messages
    if config.antiSpam.preventDuplicateMessages and playerData.lastMessage and message:find(playerData.lastMessage, 1, true) then
        player:sendRichMessage(config.antiSpam.duplicateMessageWarning)
        event:setCancelled(true)
        return
    end

    -- Add current message timestamp
    table.insert(playerData.messages, currentTime)
    playerData.lastMessage = message -- Update the last message

    -- Check for spam
    if #playerData.messages > config.antiSpam.maxMessages then
        -- Player is spamming, put them on cooldown
        playerData.cooldownUntil = currentTime + config.antiSpam.cooldownTime
        player:sendRichMessage(config.antiSpam.blockMessage)

        if config.antiSpam.logToConsole then
            print("<yellow>[Anti-Spam] Player " .. playerName .. " was temporarily muted for spamming.")
        end

        event:setCancelled(true)
    elseif #playerData.messages >= config.antiSpam.maxMessages - 1 then
        -- Warn player they're close to spam limit
        player:sendRichMessage(config.antiSpam.warningMessage)
    end

    -- Clean up old messages periodically
    cleanupOldMessages()
end)
