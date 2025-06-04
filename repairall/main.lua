local config = require("config")
local experience = require("experience")
local Damageable = import "org.bukkit.inventory.meta.Damageable"

script:registerCommand(function (sender, args)
    ---@cast sender org.bukkit.entity.Player

    local currentXP = experience.getPlayerExp(sender)
    local inventory = sender:getInventory()
    local itemsToRepair = {}
    local xpNeeded = 0
    -- First pass: calculate total XP needed and collect items
    for i = 0, inventory:getSize() - 1 do
        local item = inventory:getItem(i)
        if not item or item:isEmpty() then goto continue end

        local meta = item:getItemMeta()
        if not Damageable.class:isInstance(meta) then goto continue end
        ---@cast meta org.bukkit.inventory.meta.Damageable

        local damage = meta:getDamage()
        if damage > 0 then
            local xpForItem = damage * config.xpPerDurability
            xpNeeded = xpNeeded + xpForItem
            table.insert(itemsToRepair, {slot = i, item = item, meta = meta})
        end

        ::continue::
    end

    if xpNeeded == 0 then
        sender:sendRichMessage("<red>None of your items need repairing.")
        return
    end

    if xpNeeded > currentXP then
        sender:sendRichMessage(string.format("<red>You need %.1f XP to repair all items. You only have %.1f XP.", xpNeeded, currentXP))
        return
    end

    -- Second pass: deduct XP and repair
    experience.setPlayerExp(sender, currentXP - xpNeeded)

    for _, data in ipairs(itemsToRepair) do
        data.meta:setDamage(0)
        data.item:setItemMeta(data.meta)
        inventory:setItem(data.slot, data.item)
    end

    sender:sendRichMessage(string.format("<green>Successfully repaired %d items for %.1f XP!", #itemsToRepair, xpNeeded))
end, {
    name = "repairall",
    description = "Repair all items in your inventory",
    usage = "/repairall",
    permission = "firevanilla.repairall"
})


script:registerCommand(function (sender, args)
    -- Debug command to damage the item in hand
    ---@cast sender org.bukkit.entity.Player
    local item = sender:getInventory():getItemInMainHand()
    if not item or item:isEmpty() then
        sender:sendRichMessage("<red>You must hold an item to damage it.</red>")
        return
    end
    local meta = item:getItemMeta()
    if not Damageable.class:isInstance(meta) then
        sender:sendRichMessage("<red>The item in hand cannot be damaged.</red>")
        return
    end
    ---@cast meta org.bukkit.inventory.meta.Damageable

    local damage = meta:getDamage()

    -- Damage the item by 10 durability points
    meta:setDamage(damage + 10)
    item:setItemMeta(meta)
end, {
    name = "damageitem",
    permission = "firevanilla.damageitem",
})