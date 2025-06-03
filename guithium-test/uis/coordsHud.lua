local Component = import("net.kyori.adventure.text.Component")
local Screen = import("net.pl3x.guithium.api.gui.Screen")
local Text = import("net.pl3x.guithium.api.gui.element.Text")
local Key = import("net.pl3x.guithium.api.key.Key")
local Guithium = import("net.pl3x.guithium.api.Guithium")

---@class CoordsHud
---@field player net.pl3x.guithium.api.player.WrappedPlayer
---@field screen net.pl3x.guithium.api.gui.Screen
---@field elements table<string, net.pl3x.guithium.api.gui.element.Element>
---@field elements.text net.pl3x.guithium.api.gui.element.Text
local CoordsHud = {}
CoordsHud.__index = CoordsHud

local CoordsHudInstances = {}

---@param player net.pl3x.guithium.api.player.WrappedPlayer
function CoordsHud.new(player)
    local self = setmetatable({}, CoordsHud)
    self.player = player
    self.screen = Screen(Key:of("test:coords_hud"), true)
    self.elements = {
        text = Text("test:coords"):setPos(3, 1)
    }
    self.screen:addElement(self.elements.text)
    CoordsHudInstances[player:getUUID()] = self
    return self
end

---@param player org.bukkit.entity.Player
---@return CoordsHud|nil
function CoordsHud.getOrNew(player)
    local playerUUID = player:getUniqueId():toString()
    if CoordsHudInstances[playerUUID] then
        return CoordsHudInstances[playerUUID]
    end
    local guithiumPlayer = Guithium:api():getPlayerManager():get(player)
    if not guithiumPlayer then
        print("Player not found: " .. playerUUID)
        return nil
    end
    return CoordsHud.new(guithiumPlayer)
end

function CoordsHud:update()
    local player = server:getPlayer(self.player:getUUID())
    if not player then
        print("Player not found: " .. self.player:getUUID())
        -- Player is offline, remove the HUD
        if CoordsHudInstances[self.player:getUUID()] then
            CoordsHudInstances[self.player:getUUID()]:close()
        end
        return
    end
    self.elements.text:setText(Component:text(string.format("X: %d, Y: %d, Z: %d", 
        math.floor(player:getLocation():getX()),
        math.floor(player:getLocation():getY()),
        math.floor(player:getLocation():getZ())
    )))
    self.elements.text:send(self.player)
end

function CoordsHud:open()
    self.screen:open(self.player)
end

function CoordsHud:close()
    self.screen:close(self.player)
    CoordsHudInstances[self.player:getUUID()] = nil
end

return CoordsHud