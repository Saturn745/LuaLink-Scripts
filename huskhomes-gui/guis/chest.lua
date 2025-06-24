local GUI = require "gui.gui"
return function (homes)
    -- Calculate the size of the GUI based on the number of homes
    local size = #homes * 2 + 1
    local gui = GUI.new("Homes", size)
    
    for i = 1, #homes do
        local home = homes[i]
        ---Calculate the slot for the home, try to align in the middle, we need to keep track of the free slots
        local slot = i * 2 - 1
        
    end
end