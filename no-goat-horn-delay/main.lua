local Material = import "org.bukkit.Material"
script:registerListener("org.bukkit.event.player.PlayerInteractEvent", function(event)
    local player = event:getPlayer()
    scheduler:runDelayed(function ()
        player:setCooldown(Material.GOAT_HORN, 0)
    end, 1) -- Delay by 1 tick
end)