-- script.d.tl - Type definitions for LuaLink Script API

-- Command sender from Bukkit
global record CommandSender
    -- Add Bukkit CommandSender methods as needed
    getName: function(CommandSender): string
    sendMessage: function(CommandSender, string)
    hasPermission: function(CommandSender, string): boolean
end

-- Event priority enumeration
global enum EventPriority
    "LOWEST"
    "LOW" 
    "NORMAL"
    "HIGH"
    "HIGHEST"
    "MONITOR"
end

-- Command metadata structure
global record LuaLinkCommandMetadata
    name: string
    description: string
    usage: string
    aliases: {string}
    permission: string
    tabComplete: function(CommandSender, {string}): {string}
end

-- Event handler function type
global type EventHandler = function(any)

-- Command handler function type  
global type CommandHandler = function(CommandSender, {string})

-- Load/unload handler function type
global type LifecycleHandler = function()

-- Internal command registration structure
local record CommandRegistration
    handler: CommandHandler
    metadata: LuaLinkCommandMetadata
end

-- Internal event hook structure  
local record EventHook
    priority: EventPriority
    handler: EventHandler
end

-- Main Script class
global record Script
    -- Lifecycle management
    onLoad: function(Script, function())
    onUnload: function(Script, function())
    
    -- Internal lifecycle methods (should not be called by user scripts)
    _callLoadHandlers: function(Script)
    _callUnloadHandlers: function(Script)
    
    -- Utility methods
    getDataFolder: function(Script): string
    
    -- Command registration
    registerCommand: function(Script, CommandHandler, LuaLinkCommandMetadata)
    
    -- Event registration - overloaded for different signatures
    registerListener: function(Script, string, EventHandler)
    registerListener: function(Script, string, EventPriority, EventHandler)
end

-- Global script instance available to all scripts
global script: Script