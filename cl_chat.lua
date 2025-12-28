-- Client-side chat clear handler (fixed)
RegisterNetEvent('chat:clear')
AddEventHandler('chat:clear', function()
    -- This is the native way the default chat resource clears messages
    -- It sends a message to the NUI to clear the chat history
    SendNUIMessage({
        meth = 'clear'
    })
end)

-- Client-side handler for /me 3D text
RegisterNetEvent('chat:displayMe', function(senderServerId, message)
    local senderPed = GetPlayerPed(GetPlayerFromServerId(senderServerId))
    
    if senderPed == 0 or senderPed == -1 then return end
    
    local displayTime = 15000  -- 15 seconds
    local startTime = GetGameTimer()
    
    CreateThread(function()
        while GetGameTimer() - startTime < displayTime do
            local playerPed = PlayerPedId()
            local senderPos = GetEntityCoords(senderPed)
            local headPos = senderPos + vector3(0.0, 0.0, 1.0)  -- Slightly above head
            
            -- Check distance for visibility (adjust 20.0 for range)
            if #(GetEntityCoords(playerPed) - senderPos) < 20.0 then
                DrawText3D(headPos.x, headPos.y, headPos.z, '* ' .. message .. ' *')
            end
            
            Wait(0)
        end
    end)
end)

-- 3D text drawing function
function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(173, 216, 230, 255)  -- Light purple color (adjust as needed)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0 + 0.0125, 0.017 + factor, 0.03, 0, 0, 0, 75)  -- Optional subtle background
    ClearDrawOrigin()
end

RegisterNetEvent('chat:openGamesHelp', function()
    lib.registerContext({
        id = 'rp_games_help',
        title = '🎲 Chat Games Help',
        options = {
            {
                title = '/roll [max]',
                description = 'Roll a dice (default 1-100, max 10000)',
                icon = 'dice',
                onSelect = function()
                    lib.notify({ title = 'Examples', description = '/roll\n/roll 20', type = 'info' })
                end
            },
            {
                title = '/dice',
                description = 'Roll two six-sided dice',
                icon = 'dice',
                onSelect = function()
                    lib.notify({ title = 'Example', description = '/dice → e.g. 4 + 3 = 7 🎲', type = 'info' })
                end
            },
            {
                title = '/flip',
                description = 'Flip a coin',
                icon = 'coins',
                onSelect = function()
                    lib.notify({ title = 'Example', description = '/flip → Heads or Tails 🪙', type = 'info' })
                end
            },
            {
                title = '/rps [rock|paper|scissors]',
                description = 'Rock Paper Scissors vs server',
                icon = 'dice',
                onSelect = function()
                    lib.notify({ title = 'Examples', description = '/rps rock\n/rps paper', type = 'info' })
                end
            },
            {
                title = '/8ball [question]',
                description = 'Ask the Magic 8-Ball',
                icon = 'dice',
                onSelect = function()
                    lib.notify({ title = 'Example', description = '/8ball Will I win?', type = 'info' })
                end
            },
        }
    })
    lib.showContext('rp_games_help')
end)