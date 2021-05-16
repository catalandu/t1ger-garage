-------------------------------------
------- Created by T1GER#9080 -------
------- Cracked by UpLeaks ---------
-------------------------------------

local authoriseID = 'FUCKYOURMOTHERT1GER'

AddEventHandler('onMySQLReady', function()
    MySQL.Sync.execute("UPDATE owned_vehicles SET state=1 WHERE state=0", {})
end)

AddEventHandler('playerDropped', function (reason)
    local xPlayer = GetPlayerIdentifiers(source)[1]
    MySQL.Sync.execute("UPDATE owned_vehicles SET state = 1 WHERE owner = @owner",{['@owner'] = xPlayer})
end)

RegisterServerEvent('t1ger_garage:updateState')
AddEventHandler('t1ger_garage:updateState', function(plate, state)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Sync.execute("UPDATE owned_vehicles SET state = @state WHERE plate = @plate AND owner = @identifier",{['@state'] = state , ['@plate'] = plate, ['@identifier'] = xPlayer.getIdentifier()})
end)

RegisterServerEvent('t1ger_garage:impoundVehicleSV')
AddEventHandler('t1ger_garage:impoundVehicleSV', function(vehProps, vehFuel, label)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate, fuel, vehicle = vehProps.plate, vehFuel, json.encode(vehProps)
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate",{['@plate'] = plate}, function(impoundVeh)
        if #impoundVeh > 0 then
            for k,v in pairs(impoundVeh) do
                MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle = @vehicle, garage = @garage, fuel = @fuel, state = @state WHERE plate = @plate", {
                    ['@vehicle'] = vehicle,
                    ['@plate'] = plate,
                    ['@garage'] = label,
                    ['@fuel'] = fuel,
                    ['@state'] = 1
                })
                break
            end
        end
    end)
end)

RegisterServerEvent('t1ger_garage:releaseSeizedVeh')
AddEventHandler('t1ger_garage:releaseSeizedVeh', function(plate, state)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Sync.execute("UPDATE owned_vehicles SET garage = NULL, state = @state WHERE plate = @plate",{['@state'] = state , ['@plate'] = plate})
end)

RegisterServerEvent('t1ger_garage:getPlyGarages')
AddEventHandler('t1ger_garage:getPlyGarages', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT garageID FROM users WHERE identifier = @identifier",{['@identifier'] = xPlayer.identifier}, function(data)
        local garageID = data[1].garageID
        TriggerClientEvent('t1ger_garage:applyPlyGarage', -1, garageID)
    end)
end)

RegisterServerEvent('t1ger_garage:leaveGarageSV')
AddEventHandler('t1ger_garage:leaveGarageSV', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    for j,ply in pairs (takenSpawn) do
        if xPlayer.getIdentifier() == ply.player then
            Config.GarageSpawns[ply.spawn].inUse = false
            table.remove(takenSpawn,j)
            break
        end
    end
    TriggerClientEvent('t1ger_garage:leaveGarageCL', xPlayer.source, id)
end)  --[[  
██╗░░░██╗██████╗░██╗░░░░░███████╗░█████╗░██╗░░██╗░██████╗
██║░░░██║██╔══██╗██║░░░░░██╔════╝██╔══██╗██║░██╔╝██╔════╝
██║░░░██║██████╔╝██║░░░░░█████╗░░███████║█████═╝░╚█████╗░
██║░░░██║██╔═══╝░██║░░░░░██╔══╝░░██╔══██║██╔═██╗░░╚═══██╗
╚██████╔╝██║░░░░░███████╗███████╗██║░░██║██║░╚██╗██████╔╝
░╚═════╝░╚═╝░░░░░╚══════╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░
█████████████████████████████████████████████████████████
discord.gg/6CRxjqZJFB ]]--