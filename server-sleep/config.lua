return {
    percentRequired = 50, -- Percentage of players that must be sleeping

    onNightSkipped = function()
        -- Actions to perform when night is skipped
        server:sendRichMessage("<green>The night has been skipped!")
    end,
    
    onSleepUpdate = function(currentSleeping, required, totalOnline)
        server:sendRichMessage(("<yellow>%d/%d players sleeping (need %d to skip)")
            :format(currentSleeping, totalOnline, required))
    end
}
