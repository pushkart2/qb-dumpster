RegisterServerEvent('qb:server:startDumpsterTimer')
AddEventHandler('qb:server:startDumpsterTimer', function(dumpster)
    startTimer(source, dumpster)
end)

RegisterServerEvent('qb:server:giveDumpsterReward')
AddEventHandler('qb:server:giveDumpsterReward', function()
    local xPlayer = QBCore.Functions.GetPlayer(source) 
    local randomItem = Config.Items[math.random(1, #Config.Items)]
    if xPlayer.Functions.AddItem(randomItem, 1) then
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items[randomItem], "add")
    else
        TriggerClientEvent("QBCore:Notify", source, "You dont have enough space", "error")
    end
end)

local timer = Config.WaitTime * 60 * 1000

function startTimer(id, object)
    Citizen.CreateThread(function()
        Citizen.Wait(timer)
        TriggerClientEvent('qb:server:startDumpsterTimer', id, object)
    end)
end
