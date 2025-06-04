-- experience.lua

local experience = {}

--- Calculate the experience required to progress to the next level.
---@param level integer
---@return integer
local function getExpToNext(level)
    if level >= 30 then
        return level * 9 - 158
    elseif level >= 15 then
        return level * 5 - 38
    else
        return level * 2 + 7
    end
end

--- Calculate total experience from level only.
---@param level integer
---@return integer
function experience.getExpFromLevel(level)
    if level > 30 then
        return math.floor(4.5 * level * level - 162.5 * level + 2220)
    elseif level > 15 then
        return math.floor(2.5 * level * level - 40.5 * level + 360)
    else
        return level * level + 6 * level
    end
end

--- Get total experience from level and progress to next level.
---@param level integer
---@param progress number Progress to next level (0.0 to 1.0)
---@return integer
function experience.getExp(level, progress)
    return experience.getExpFromLevel(level) + math.floor(getExpToNext(level) * progress + 0.5)
end

--- Calculate level including partial progress from total experience.
---@param exp number
---@return number
function experience.getLevelFromExp(exp)
    local level = experience.getIntLevelFromExp(exp)
    local remainder = exp - experience.getExpFromLevel(level)
    local progress = remainder / getExpToNext(level)
    return level + progress
end

--- Calculate integer level from total experience.
---@param exp number
---@return integer
function experience.getIntLevelFromExp(exp)
    if exp > 1395 then
        return math.floor((math.sqrt(72 * exp - 54215) + 325) / 18)
    elseif exp > 315 then
        return math.floor(math.sqrt(40 * exp - 7839) / 10 + 8.1)
    elseif exp > 0 then
        return math.floor(math.sqrt(exp + 9) - 3)
    else
        return 0
    end
end


--- Calculate total experience from a player object (with getLevel() and getExp()).
---@param player org.bukkit.entity.Player
---@return integer
function experience.getPlayerExp(player)
    local level = player:getLevel()
    local progress = player:getExp() -- this is a float between 0.0 and 1.0
    return experience.getExpFromLevel(level) + math.floor(getExpToNext(level) * progress + 0.5)
end

--- Set the player's experience.
--- @param player org.bukkit.entity.Player
--- @param exp number Total experience to set
--- @return boolean
function experience.setPlayerExp(player, exp)
    if not player or not player:isOnline() then
        return false
    end

    local level = experience.getIntLevelFromExp(exp)
    local progress = (exp - experience.getExpFromLevel(level)) / getExpToNext(level)

    player:setLevel(level)
    player:setExp(progress)

    return true
end


return experience