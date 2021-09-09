QBCore = nil

local searched = {3423423424}
local canSearch = true
local dumpsters = {218085040, 666561306, -58485588, -206690185, 1511880420, 682791951}
local searchTime = 14000
local idle = 0
local dumpPos
local nearDumpster = false
local maxDistance = 2.5
local listening = false
local dumpster
local currentCoords = nil
local realDumpster

Citizen.CreateThread(function() 
    while QBCore == nil do
        TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
        Citizen.Wait(200)
    end
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    local dist = 0
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local playerCoords, awayFromGarbage = GetEntityCoords(PlayerPedId()), true
        if not nearDumpster then
            for i = 1, #dumpsters do
                local distance
                dumpster = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, dumpsters[i], false, false, false)
                if dumpster ~= 0 then
                    realDumpster = dumpster 
                end
                dumpPos = GetEntityCoords(dumpster)
                local distance = #(pos - dumpPos)
                if distance < maxDistance then
                    currentCoords = dumpPos
                end
                if distance < maxDistance then
                    awayFromGarbage = false
                    nearDumpster = true
                    if not listening then
                        dumpsterKeyPressed()
                    end
                end
            end
        end
        if currentCoords ~= nil and #(currentCoords - playerCoords) > maxDistance then
            nearDumpster = false
            listening = false
        end
        if awayFromGarbage then
            Citizen.Wait(1000)
        end
    end
end)

function dumpsterKeyPressed()
    listening = true
    Citizen.CreateThread(function()
        while listening do
            local dumpsterFound = false
            Citizen.Wait(0)
            DrawText3D(currentCoords.x, currentCoords.y, currentCoords.z + 1.0, '~g~E~w~ - dumpster dive')
            if IsControlJustReleased(0, 54) then
                for i = 1, #searched do
                    if searched[i] == realDumpster then
                        dumpsterFound = true
                    end
                    if i == #searched and dumpsterFound then
                        QBCore.Functions.Notify('This dumpster has already been searched', 'error')
                    elseif i == #searched and not dumpsterFound then
                        QBCore.Functions.Notify('You begin to search the dumpster', 'success')
                        QBCore.Functions.Progressbar("dumpsters", "Searching Dumpster", 1000, false, false, {
                            disableMovement = false,
                            disableCarMovement = false,
                            disableMouse = false,
                            disableCombat = false,
                        }, {
                            animDict = "amb@prop_human_bum_bin@base",
                            anim = "base",
                            flags = 49,
                        }, {}, {}, function()
                            TriggerServerEvent("qb-dumpster:server:giveDumpsterReward")
                            TriggerServerEvent('qb-dumpster:server:startDumpsterTimer', dumpster)
                            table.insert(searched, realDumpster)
                        end, function()
                            QBCore.Functions.Notify('You cancelled the search', 'error')
                        end)
                    end
                end
            end
        end
    end)
end