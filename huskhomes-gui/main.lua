local Player = import "org.bukkit.entity.Player"
local FloodgateAPI = import "org.geysermc.floodgate.api.FloodgateApi"
local HuskHomesAPI = import "net.william278.huskhomes.api.HuskHomesAPI"

script:registerCommand(function(sender, args)
    if not Player.class:isInstance(sender) then
        sender:sendRichMessage("<red>Only players can use this command!</red>")
        return
    end
    ---@cast sender org.bukkit.entity.Player
    
    ---@type net.william278.huskhomes.user.OnlineUser
    local huskUser = HuskHomesAPI:getInstance():adaptUser(sender)
    local homes = {}
    HuskHomesAPI:getUserHomes(huskUser):thenAccept(function (homeList)
        ---@cast homeList java.util.List<net.william278.huskhomes.position.Home>
        for i = 1, homeList:size() do
            ---@type net.william278.huskhomes.position.Home
            local home = homeList:get(i - 1)
            table.insert(homes, {
                name = home:getMeta():getName(),
            })
        end
    end)
    sender:setCooldown
    if not FloodgateAPI:getInstance():isFloodgatePlayer(sender:getUniqueId()) then
        sender:sendRichMessage("Java Player")
    else
        sender:sendRichMessage("Bedrock Player")
    end
end, {
    name = "homes",
    permission = "gal8xy.homesgui"
})
