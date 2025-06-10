local PlaceholderAPI = import "me.clip.placeholderapi.PlaceholderAPI"
local LuckPermsProvider = import "net.luckperms.api.LuckPermsProvider"
local InheritanceNode = import "net.luckperms.api.node.types.InheritanceNode"
local UUID = import "java.util.UUID"
local config = require("config")

local BALTOP_PLAYER_DATA_FILE = script:getDataFolder().."/baltop-player.data"

local CHECK_INTERVAL_TICKS = config.checkInterval * 60 * 20 -- Convert minutes to ticks (assuming 20 ticks per second)

script:onLoad(function ()
    -- Ensure the baltop-player.data file exists
    local baltopPlayerFile = io.open(BALTOP_PLAYER_DATA_FILE, "a")
    if baltopPlayerFile then
        baltopPlayerFile:close()
    else
        print("Could not create baltop-player.data file.")
    end
end)

scheduler:runRepeatingAsync(function ()
    local topPlayerName = PlaceholderAPI:setPlaceholders(nil, "%ajlb_lb_vault_eco_balance_1_alltime_name%")
    if not topPlayerName or topPlayerName == "" then
        print("No baltop player found.")
        return
    end

    print("Top player: " .. topPlayerName)
    local topPlayer = server:getOfflinePlayer(topPlayerName)

    -- Read the last player with the rank from the basic text file baltop-player.data
    local lastPlayerUUIDFile = io.open(BALTOP_PLAYER_DATA_FILE, "r")
    -- The only thing in this file is the UUID of the last player with the rank
    if not lastPlayerUUIDFile then
        print("Could not open baltop-player.data file.")
        return
    end
    local lastPlayerUUID = lastPlayerUUIDFile:read("*l")
    lastPlayerUUIDFile:close()
    -- If the file is empty, we assume no player has the rank yet
    -- If the file is not empty, check if it it's the same as the player we just found and if it is, we return
    if lastPlayerUUID and lastPlayerUUID ~= "" then
        if lastPlayerUUID == topPlayer:getUniqueId():toString() then
            print("Top player stayed the same, no rank change needed.")
            return
        end
    end
    -- If we reach this point, we know the top player has changed and we can proceed to give them the rank and remove it from the last player
    
    local lpUser = LuckPermsProvider:get():getUserManager():loadUser(topPlayer:getUniqueId(), topPlayerName):join()
    lpUser:data():add(
        InheritanceNode:builder(config.rank):value(true):build()
    )
    LuckPermsProvider:get():getUserManager():saveUser(lpUser)

    print("Gave rank " .. config.rank .. " to player " .. topPlayerName)
    -- Write the new player's UUID to the baltop-player.data file
    lastPlayerUUIDFile = io.open(BALTOP_PLAYER_DATA_FILE, "w")
    if not lastPlayerUUIDFile then
        print("Could not open baltop-player.data file for writing.")
        return
    end
    lastPlayerUUIDFile:write(topPlayer:getUniqueId():toString())
    lastPlayerUUIDFile:close()
    -- Remove the rank from the last player if they exist
    if lastPlayerUUID and lastPlayerUUID ~= "" then
        print("Trying to remove rank from last player with UUID: " .. lastPlayerUUID)
        local lastLpUser = LuckPermsProvider:get():getUserManager():loadUser(UUID:fromString(lastPlayerUUID)):join()
        ---@cast lastLpUser net.luckperms.api.model.user.User
        lastLpUser:data():remove(InheritanceNode:builder(config.rank):value(true):build())
        LuckPermsProvider:get():getUserManager():saveUser(lastLpUser)
        print("Removed rank " .. config.rank .. " from player " .. lastLpUser:getUsername())
    end

end, 0, CHECK_INTERVAL_TICKS)