local ITEM_NAME = "&2&l|_&a&nStarter_Kit&r_&2&l|"

---@param item org.bukkit.inventory.ItemStack
local function checkItem(item)
    if item == nil then
        return false
    end

    local itemName = item:getItemMeta():getDisplayName()

    if itemName == ITEM_NAME then
        return true
    end

    return false
    
end

script:registerListener("org.bukkit.event.inventory.PrepareAnvilEvent", function(event)
    
    local firstItem = event:getInventory():getFirstItem()
    local secondItem = event:getInventory():getSecondItem()
     if firstItem ~= nil then
        if checkItem(firstItem) then
            event:setResult(nil) -- Block the anvil operation
        end
     end
    if secondItem ~= nil then
        if checkItem(secondItem) then
            event:setResult(nil) -- Block the anvil operation
        end
    end

end)