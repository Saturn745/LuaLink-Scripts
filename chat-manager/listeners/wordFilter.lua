local profanity_filter = require("utils.profanity_filter")
local config = require("config")

if config.wordFilter.blockInChat then
    script:registerListener("io.papermc.paper.event.player.AsyncChatEvent", function(event)
        local message = event:signedMessage():message()
        if profanity_filter.containsProfanity(message) then
            local player = event:getPlayer()
            player:sendRichMessage(config.wordFilter.blockedMessage)
            event:setCancelled(true)
        end
    end)
end

if config.wordFilter.blockInCommands then
    script:registerListener("org.bukkit.event.player.PlayerCommandPreprocessEvent", function(event)
        local command = event:getMessage()
        if command:sub(1, 1) == "/" then
            command = command:sub(2) -- Remove leading slash
        end

        if profanity_filter.containsProfanity(command) then
            local player = event:getPlayer()
            player:sendRichMessage(config.wordFilter.blockedMessage)
            event:setCancelled(true)
        end
    end)
end

if config.wordFilter.blockInSigns then
    script:registerListener("org.bukkit.event.block.SignChangeEvent", function(event)
        local lines = event:lines()
        for i = 1, lines:size() do
            local line = event:line(i - 1) -- Lua momento
            if line == nil then
                goto continue
            end
            ---@cast line net.kyori.adventure.text.TextComponent
            local text = line:content()
            if profanity_filter.containsProfanity(text) then
                local player = event:getPlayer()
                player:sendRichMessage(config.wordFilter.blockedMessage)
                event:setCancelled(true)
                return
            end
            ::continue::
        end
    end)
end
