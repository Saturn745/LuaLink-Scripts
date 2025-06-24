local MiniMessage = import "net.kyori.adventure.text.minimessage.MiniMessage"
local config = require "config"
script:registerCommand(function (sender, args)
    local message = table.concat(java.luaify(args), " ")
    message = config.prefix .. " " .. message
    server:broadcast(MiniMessage:miniMessage():deserialize(message))
end, {
    name = "broadcast",
    description = "Broadcasts a message to all players",
    usage = "/broadcast <message>",
    permission = "gal8xy.broadcast"
})