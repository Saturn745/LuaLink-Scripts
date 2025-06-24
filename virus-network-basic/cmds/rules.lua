local config = require "config"
script:registerCommand(function (sender, args)
    for i = 1, #config.rules do
        sender:sendRichMessage(config.rules[i])
    end
end, {
    name = "rules",
})