local json = require "json"

script:onLoad(function ()
    -- If the file is not present or empty create it with an empty array
    local dataFilePath = script:getDataFolder().."/data.json"
    local file = io.open(dataFilePath, "r")
    if not file then
        file = io.open(dataFilePath, "w")
        if file then
            file:write("[]")  -- Initialize with an empty JSON array
            file:close()
        else
            error("Could not create data.json")
        end
    else
        local content = file:read("*a")
        file:close()
        if content == "" then
            file = io.open(dataFilePath, "w")
            if file then
                file:write("[]")  -- Initialize with an empty JSON array
                file:close()
            else
                error("Could not create data.json")
            end
        end
    end
    print("JSON Test Script Loaded. Use /jsonTest <action> to test.")
end)

script:registerCommand(function (sender, args)
    if #args == 0 then
        sender:sendMessage("Usage: /jsonTest <action>")
        return
    end

    local action = args[1]:lower()
    if action == "encode" then
        -- Append random data to the data.json array
        -- Data is random each time
        local file = io.open(script:getDataFolder().."/data.json", "r")
        local content = file:read("*a")
        file:close()
        local data = json.decode(content)
        if not data or type(data) ~= "table" then
            data = {}
        end
        local newData = {
            name = "Random User " .. math.random(1, 100),
            age = math.random(18, 65),
            isEmployed = math.random() > 0.5,
            skills = { "Skill " .. math.random(1, 10), "Skill " .. math.random(1, 10) },
            address = {
                street = "Random St " .. math.random(1, 100),
                city = "Random City",
                zip = tostring(math.random(10000, 99999))
            }
        }
        table.insert(data, newData)
        -- Write the updated data back to the data.json file
        file = io.open(script:getDataFolder().."/data.json", "w")
        if file then
            file:write(json.encode(data))
            file:close()
            sender:sendMessage("Data encoded and written to data.json")
        else
            sender:sendMessage("Could not write to data.json")
        end
    
    elseif action == "read" then
        -- Read and decode the JSON data from the data.json file
        local file = io.open(script:getDataFolder().."/data.json", "r")
        if file then
            local content = file:read("*a")
            file:close()
            local data = json.decode(content)
            sender:sendMessage("Decoded JSON data:")
            for k, v in pairs(data) do
                sender:sendMessage(k .. ": " .. tostring(v))
            end
        else
            sender:sendMessage("Could not read data.json")
        end
    else
        sender:sendMessage("Unknown action: " .. action)
        sender:sendMessage("Available actions: encode, read")
    end
end, {
    name = "jsonTest",
    description = "Test JSON encoding and decoding",
    usage = "/jsonTest"
})