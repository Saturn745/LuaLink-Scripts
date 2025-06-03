local M = {}

-- Word blocklist (lowercase only)
local bannedWords = require("config").wordFilter.words or {}

-- Leetspeak substitutions
local leetMap = {
  ["1"] = "i",
  ["!"] = "i",
  ["3"] = "e",
  ["4"] = "a",
  ["@"] = "a",
  ["$"] = "s",
  ["5"] = "s",
  ["7"] = "t",
  ["0"] = "o",
  ["9"] = "g",
  ["+"] = "t",
  ["|"] = "i",
}

-- Normalize a word by replacing leetspeak and stripping symbols
function M.normalizeWord(word)
  word = word:lower()
  word = word:gsub("[%p%c%s]", "") -- Remove punctuation/control/whitespace

  for k, v in pairs(leetMap) do
    word = word:gsub(k, v)
  end

  return word
end

-- Split message into words
function M.tokenize(message)
  local words = {}
  for word in message:gmatch("%S+") do
    table.insert(words, word)
  end
  return words
end

-- Check for profanity
---@param message string
---@return boolean, string|nil
function M.containsProfanity(message)
  local words = M.tokenize(message)

  for _, word in ipairs(words) do
    if bannedWords[word] then -- Fast path: exact match
      return true, word
    end

    local normalized = M.normalizeWord(word)
    if bannedWords[normalized] then
      return true, normalized
    end
  end

  return false
end

return M
