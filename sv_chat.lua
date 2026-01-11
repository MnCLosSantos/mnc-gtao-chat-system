local QBCore = exports['qb-core']:GetCoreObject()
local GameCooldowns = {}

-- ============================================================================
-- AGGRESSIVE EXTERNAL MESSAGE BLOCKING - Only allow messages from THIS script
-- ============================================================================

local ourResource = GetCurrentResourceName()

-- Block all chat:addMessage calls from other scripts on SERVER
AddEventHandler('chat:addMessage', function()
    local invoker = GetInvokingResource()
    
    -- Block if not from our resource (allow nil for internal)
    if invoker ~= nil and invoker ~= ourResource then
        CancelEvent()
    end
end)

-- Block all __cfx_internal:serverPrint events
AddEventHandler('__cfx_internal:serverPrint', function()
    local invoker = GetInvokingResource()
    
    if invoker ~= nil and invoker ~= ourResource then
        CancelEvent()
    end
end)


-- ============================================================================
-- CHAT MESSAGE HANDLER
-- ============================================================================

-- Override the default chat message handler (player-typed messages only)
AddEventHandler('chatMessage', function(source, name, message)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    -- Cancel default behavior
    CancelEvent()
    
    -- Block if source is 0 (console/server generated)
    if src == 0 or src == nil then
        return
    end
    
    if not Player then
        -- Fallback to regular name if player data not loaded
        TriggerClientEvent('chat:addMessage', -1, {
            args = { name, message }
        })
        return
    end
    
    -- Get character name from QBCore
    local characterName = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
    
    -- Send message with character name
    TriggerClientEvent('chat:addMessage', -1, {
        args = { characterName, message }
    })
end)

-- ============================================================================
-- COMMANDS
-- ============================================================================

-- /me command (3D text above head)
RegisterCommand('me', function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local message = table.concat(args, ' ')
    
    if message == '' then
        TriggerClientEvent('QBCore:Notify', src, 'You must enter a message', 'error')
        return
    end
    
    -- Trigger client event to all players to display 3D text above the sender's head
    TriggerClientEvent('chat:displayMe', -1, src, message)
end, false)

-- /clear command - clears chat for the player
RegisterCommand('clear', function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('chat:clear', src)
end, false)

-- ============================================================================
-- CHAT GAMES
-- ============================================================================

-- /games - Opens a help modal with all RP game explanations
RegisterCommand('chatgames', function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('chat:openGamesHelp', src)
end, false)

-- /roll [max] (default 100, min 2, max 10000)
RegisterCommand('roll', function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local now = GetGameTimer()
    if GameCooldowns[src] and now - GameCooldowns[src] < 3000 then
        TriggerClientEvent('QBCore:Notify', src, 'Please wait 3 seconds before another game!', 'error')
        return
    end
    GameCooldowns[src] = now
    
    local maxRoll = tonumber(args[1])
    if not maxRoll or maxRoll < 2 then
        maxRoll = 100
    elseif maxRoll > 10000 then
        maxRoll = 10000
    end
    
    local roll = math.random(1, maxRoll)
    local action = "rolled a " .. roll .. " (1-" .. maxRoll .. ") 🎲"
    
    TriggerClientEvent('chat:displayMe', -1, src, action)
end, false)

-- /dice (rolls 2d6)
RegisterCommand('dice', function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local now = GetGameTimer()
    if GameCooldowns[src] and now - GameCooldowns[src] < 3000 then
        TriggerClientEvent('QBCore:Notify', src, 'Please wait 3 seconds before another game!', 'error')
        return
    end
    GameCooldowns[src] = now
    
    local die1 = math.random(1, 6)
    local die2 = math.random(1, 6)
    local total = die1 + die2
    local action = "rolled " .. die1 .. " + " .. die2 .. " = " .. total .. " 🎲"
    
    TriggerClientEvent('chat:displayMe', -1, src, action)
end, false)

-- /flip (coin flip)
RegisterCommand('flip', function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local now = GetGameTimer()
    if GameCooldowns[src] and now - GameCooldowns[src] < 3000 then
        TriggerClientEvent('QBCore:Notify', src, 'Please wait 3 seconds before another game!', 'error')
        return
    end
    GameCooldowns[src] = now
    
    local side = math.random(2) == 1 and "Heads 👑" or "Tails 🔱"
    local action = "flipped 🪙 " .. side .. "!"
    
    TriggerClientEvent('chat:displayMe', -1, src, action)
end, false)

-- /rps [rock|paper|scissors]
RegisterCommand('rps', function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local now = GetGameTimer()
    if GameCooldowns[src] and now - GameCooldowns[src] < 3000 then
        TriggerClientEvent('QBCore:Notify', src, 'Please wait 3 seconds before another game!', 'error')
        return
    end
    GameCooldowns[src] = now
    
    local playerChoice = args[1] and args[1]:lower() or ""
    if playerChoice ~= "rock" and playerChoice ~= "paper" and playerChoice ~= "scissors" then
        TriggerClientEvent('QBCore:Notify', src, 'Usage: /rps [rock|paper|scissors]', 'error')
        return
    end
    
    local choiceMap = {rock = "✊", paper = "✋", scissors = "✌️"}
    local pEmoji = choiceMap[playerChoice]
    
    local serverChoices = {"rock", "paper", "scissors"}
    local sChoice = serverChoices[math.random(3)]
    local sEmoji = choiceMap[sChoice]
    
    local outcome
    if playerChoice == sChoice then
        outcome = "Tie! 🤝"
    elseif
        (playerChoice == "rock" and sChoice == "scissors") or
        (playerChoice == "paper" and sChoice == "rock") or
        (playerChoice == "scissors" and sChoice == "paper")
    then
        outcome = "You win! 🎉"
    else
        outcome = "Server wins! 😈"
    end
    
    local action = "played " .. playerChoice .. " " .. pEmoji .. " vs " .. sChoice .. " " .. sEmoji .. " - " .. outcome
    
    TriggerClientEvent('chat:displayMe', -1, src, action)
end, false)

-- /8ball [question]
RegisterCommand('8ball', function(source, args, rawCommand)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local now = GetGameTimer()
    if GameCooldowns[src] and now - GameCooldowns[src] < 3000 then
        TriggerClientEvent('QBCore:Notify', src, 'Please wait 3 seconds before another game!', 'error')
        return
    end
    GameCooldowns[src] = now
    
    local question = table.concat(args, " ")
    if question == "" then
        TriggerClientEvent('QBCore:Notify', src, 'You must ask a question! e.g. /8ball Will it rain?', 'error')
        return
    end
    
    local answers = {
        "It is certain 🔮", "It is decidedly so 🔮", "Without a doubt 🔮", "Yes – definitely 🔮",
        "You may rely on it 🔮", "As I see it, yes 🔮", "Most likely 🔮", "Outlook good 🔮",
        "Yes 🔮", "Signs point to yes 🔮", "Reply hazy, try again 🔮", "Ask again later 🔮",
        "Better not tell you now 🔮", "Cannot predict now 🔮", "Concentrate and ask again 🔮",
        "Don't count on it 🔮", "My reply is no 🔮", "My sources say no 🔮",
        "Outlook not so good 🔮", "Very doubtful 🔮"
    }
    local answer = answers[math.random(#answers)]
    local action = 'shakes the magic 8-ball "' .. question .. '"... ' .. answer
    
    TriggerClientEvent('chat:displayMe', -1, src, action)
end, false)
