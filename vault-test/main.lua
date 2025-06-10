local VAULT_ECONOMY = import "net.milkbowl.vault.economy.Economy"
local econ = nil


script:onLoad(function ()
    local rsp = server:getServicesManager():getRegistration(VAULT_ECONOMY.class)
    if rsp ~= nil then
        econ = rsp:getProvider()
    else
        print("Vault Economy not found. Commands requiring economy will not work.")
    end
end)

script:registerCommand(function (sender, args)
    -- Should ensure the sender is a player before casting but this is testing so
    ---@cast sender org.bukkit.entity.Player
    if not econ then
        sender:sendRichMessage("<red>Vault Economy is not available.</red>")
        return
    end

    local balance = econ:getBalance(sender)
    sender:sendRichMessage(string.format("<green>Your balance is: <gold>%.2f</gold></green>", balance))

    -- Deposit example
    local amount = 100.0 -- Example amount to deposit
    econ:depositPlayer(sender, amount) -- This returns an EconomyResponse object which you can check for success or failure if you want
end, {
    name = "vault-test"
})