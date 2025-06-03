local CoordsHud = require("uis.coordsHud")
script:registerListener("org.bukkit.event.player.PlayerMoveEvent", function(event)
    --- @cast event org.bukkit.event.player.PlayerMoveEvent
    if not event:hasChangedBlock() then
        return
    end
    local coordsHud = CoordsHud.getOrNew(event:getPlayer())
    if coordsHud == nil then
        return
    end
    coordsHud:open()
    coordsHud:update()
end)

