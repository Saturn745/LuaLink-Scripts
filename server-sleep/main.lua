local config = require("config")

local sleepingPlayers = {}

local function getRequiredSleepCount(totalPlayers)
    return math.ceil((config.percentRequired / 100) * totalPlayers)
end

local function getSleepingCount()
    local count = 0
    for _ in pairs(sleepingPlayers) do
        count = count + 1
    end
    return count
end

local function updateSleepStatus()
    local totalOnline = server:getOnlinePlayers():size()
    local currentSleeping = getSleepingCount()
    local required = getRequiredSleepCount(totalOnline)

    if config.onSleepUpdate then
        config.onSleepUpdate(currentSleeping, required, totalOnline)
    end
end

-- Check if enough players are sleeping to skip the night
local function checkSleepThreshold()
    local totalOnline = server:getOnlinePlayers():size()
    if totalOnline == 0 then return end

    local sleepingCount = getSleepingCount()
    local required = getRequiredSleepCount(totalOnline)

    if sleepingCount >= required then
        -- Skip the night
        for _, world in ipairs(server:getWorlds()) do
            world:setTime(0)
            world:setStorm(false)
            world:setThundering(false)
        end

        sleepingPlayers = {}

        if config.onNightSkipped then
            config.onNightSkipped()
        end
    end
end

-- Player enters bed
script:registerListener("org.bukkit.event.player.PlayerBedEnterEvent", function(event)
    if event:isCancelled() then return end

    local player = event:getPlayer()
    sleepingPlayers[player:getUniqueId()] = true

    updateSleepStatus()
    checkSleepThreshold()
end)

-- Player leaves bed
script:registerListener("org.bukkit.event.player.PlayerBedLeaveEvent", function(event)
    local player = event:getPlayer()
    sleepingPlayers[player:getUniqueId()] = nil

    updateSleepStatus()
end)

-- Player disconnects
script:registerListener("org.bukkit.event.player.PlayerQuitEvent", function(event)
    local player = event:getPlayer()
    sleepingPlayers[player:getUniqueId()] = nil

    updateSleepStatus()
end)
