



local function add(a, b)
   return a + b
end

local s = add(1, 1)
print(s)

script:onLoad(function()
   print("Script loaded")
end)
script:onLoad(function(bad)
   print("This should not be called with an argument")
end)
