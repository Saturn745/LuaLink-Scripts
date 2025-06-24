local FloodgateAPI = import "org.geysermc.floodgate.api.FloodgateApi"
local Geyser = {}

---@param player org.bukkit.entity.Player
---@return boolean
function Geyser.IsBedrockPlayer(player)
    return FloodgateAPI:getInstance():isFloodgatePlayer(player:getUniqueId())
end

---@param player org.bukkit.entity.Player
---@return boolean
function Geyser.IsJavaPlayer(player)
    return not Geyser.IsBedrockPlayer(player)
end

return Geyser