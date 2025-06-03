local Vector = import "org.bukkit.util.Vector"
script:registerCommand(function (sender, args)
    if #args < 1 then
        sender:sendRichMessage("<red>Usage: /launch <player_name> [y] [x] [z]</red>")
        return
    end

    local playerName = args[1]
    local player = server:getPlayer(playerName)
    if not player then
        sender:sendRichMessage("<red>Player not found: " .. playerName .. "</red>")
        return
    end

    -- If there's just two arguments (player and z) don't push the player on the x or y but if there are four arguments, push the player on the x,y, and z
    local z = 0
    local x = 0
    local y = 20
    if #args >= 2 then
        y = tonumber(args[2]) or z
    end
    if #args >= 3 then
        x = tonumber(args[3]) or x
    end
    if #args >= 4 then
        z = tonumber(args[4]) or y
    end

    -- Launch the player
    player:setVelocity(Vector(x, y, z):normalize():multiply(2))
    sender:sendRichMessage("<green>Launched player " .. playerName .. " with velocity: (" .. x .. ", " .. y .. ", " .. z .. ")</green>")

end, {
    name = "__launch",
    permission = "troll.launch",
})