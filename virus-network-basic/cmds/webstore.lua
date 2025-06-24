local config = require "config"
local Geyser = require "utils.geyser"
local SimpleForm = import "org.geysermc.cumulus.form.SimpleForm"

script:registerCommand(function (sender, args)
    sender:sendRichMessage(string.format([[
    <font:minecraft:uniform><gradient:#00d4aa:#017a74><bold>🛒 Webstore</bold></gradient></font>

    <hover:show_text:'Click to open our store!'><click:open_url:'%s'><color:#4fc3f7><underlined>» Visit Store «</underlined></color></click></hover>
    ]], config.storeURL))
end, {
    name = "store",
    description = "Gives a link to the webstore",
    usage = "/store",
})