-------------------------------------
------- Created by T1GER#9080 -------
------- Cracked by UpLeaks ---------
-------------------------------------

ESX = nil
TriggerEvent('esx:getShDFWMaredObjDFWMect', function(obj) ESX = obj end)

ESX.RegisterServerCallback('t1ger_garage:getGarageList', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehList = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier",{['@identifier'] = xPlayer.getIdentifier()}, function(results) 
		for k,v in pairs(results) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehList,{vehicle = vehicle, plate = v.plate, garage = v.garage})
		end
		cb(vehList)
	end)
end)

ESX.RegisterServerCallback('t1ger_garage:fetchVehicles', function(source, cb, label)
	local xPlayer = ESX.GetPlayerFromId(source)
	local vehList = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND (garage = @garage OR garage IS NULL) AND state=1",{['@identifier'] = xPlayer.getIdentifier(), ['@garage'] = label}, function(results) 
		for k,v in pairs(results) do
			local vehicle = json.decode(v.vehicle)
			table.insert(vehList,{vehicle = vehicle, plate = v.plate, fuel = v.fuel})
		end
		cb(vehList)
	end)
end)

ESX.RegisterServerCallback('t1ger_garage:fetchImpoundedVehicles', function(source, cb, label)
	local xPlayer = ESX.GetPlayerFromId(source)
	local impoundVehList = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND garage = @garage",{['@identifier'] = xPlayer.getIdentifier(), ['@garage'] = label}, function(results) 
		for k,v in pairs(results) do
			local vehicle = json.decode(v.vehicle)
			table.insert(impoundVehList,{vehicle = vehicle, plate = v.plate})
		end
		cb(impoundVehList)
	end)
end)

ESX.RegisterServerCallback('t1ger_garage:fetchSeizedVehicles', function(source, cb, label)
	local xPlayer = ESX.GetPlayerFromId(source)
	local seizedVehList = {}

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE garage = @garage",{['@garage'] = label}, function(results) 
		for k,v in pairs(results) do
			local vehicle = json.decode(v.vehicle)
			table.insert(seizedVehList,{vehicle = vehicle, plate = v.plate})
		end
		cb(seizedVehList)
	end)
end)

ESX.RegisterServerCallback('t1ger_garage:getImpoundFees', function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    local impoundFees = tonumber(Config.ImpoundFees)
    local money = 0
    if Config.PayImpoundWithCash then
        money = xPlayer.getMoney()
    else
        money = xPlayer.getAccount('bank').money
    end
    if money >= impoundFees then
        if Config.PayImpoundWithCash then
            xPlayer.removeMoney(impoundFees)
        else
            xPlayer.removeAccountMoney('bank', impoundFees)
        end
        MySQL.Sync.execute("UPDATE owned_vehicles SET garage = NULL WHERE plate = @plate AND owner = @owner",{['@plate'] = plate, ['@owner'] = xPlayer.getIdentifier()})
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('t1ger_garage:getVehicleFuel', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)
    local VehFuel = nil
	MySQL.Async.fetchAll("SELECT fuel FROM owned_vehicles WHERE plate=@plate",{['@plate'] = plate}, function(data) 
        if data[1] ~= nil then
            if data[1].fuel ~= nil then
                VehFuel = data[1].fuel
                cb(VehFuel)
            else
                cb(VehFuel)
            end
        else
            cb(VehFuel)
        end
	end)
end)

ESX.RegisterServerCallback('t1ger_garage:storeVehicle',function(source, cb, label, vehProps, vehFuel)
	local xPlayer = ESX.GetPlayerFromId(source)
    local plate, fuel, vehicle = vehProps.plate, vehFuel, json.encode(vehProps)
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner and plate = @plate",{['@owner'] = xPlayer.getIdentifier(), ['@plate'] = plate}, function(foundVeh)
        if #foundVeh > 0 then
            for k,v in pairs(foundVeh) do
                MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle = @vehicle, garage = @garage, fuel = @fuel WHERE owner = @identifier AND plate = @plate", {
                    ['@vehicle'] = vehicle,
                    ['@identifier'] = xPlayer.getIdentifier(),
                    ['@plate'] = plate,
                    ['@garage'] = label,
                    ['@fuel'] = fuel
                })
                cb(true)
                break
            end
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback('t1ger_garage:seizeVehicle',function(source, cb, label, vehProps, vehFuel)
	local xPlayer = ESX.GetPlayerFromId(source)
    local plate, fuel, vehicle = vehProps.plate, vehFuel, json.encode(vehProps)
    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE plate = @plate",{['@plate'] = plate}, function(foundPlate)
        if #foundPlate > 0 then
            for k,v in pairs(foundPlate) do
                MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle = @vehicle, garage = @garage, fuel = @fuel, state = @state WHERE plate = @plate", {
                    ['@vehicle'] = vehicle,
                    ['@plate'] = plate,
                    ['@garage'] = label,
                    ['@fuel'] = fuel,
                    ['@state'] = 1
                })
                cb(true)
                break
            end
        else
            cb(false)
        end
    end)
end)

-- PRIVATE GARAGES:

takenSpawn = {}

ESX.RegisterServerCallback('t1ger_garage:getPurchasedGarages',function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local takenGarages = {}
    MySQL.Async.fetchAll("SELECT garageID FROM t1ger_garage",{}, function(data)
        for k,v in pairs(data) do
            table.insert(takenGarages,{id = v.garageID})
        end
        cb(takenGarages)
    end)
end)

ESX.RegisterServerCallback('t1ger_garage:purchaseGarage',function(source, cb, id, val)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = 0
    if Config.PayGarageWithCash then
        money = xPlayer.getMoney()
    else
        money = xPlayer.getAccount('bank').money
    end
    if money >= val.price then
        xPlayer.removeMoney(val.price)
        MySQL.Async.execute("UPDATE users SET garageID=@garageID WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@garageID'] = id}) 
        MySQL.Sync.execute("INSERT INTO t1ger_garage (garageID) VALUES (@garageID)", {['garageID'] = id})
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('t1ger_garage:sellGarage',function(source, cb, id, val, sellPrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT garageID FROM users WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier}, function(data)
        if data[1].garageID == id then
            MySQL.Async.execute("UPDATE users SET garageID=@garageID WHERE identifier=@identifier", {['@identifier'] = xPlayer.identifier, ['@garageID'] = 0}) 
            MySQL.Async.execute("DELETE FROM t1ger_garage WHERE garageID=@garageID", {['@garageID'] = id}) 
            xPlayer.addMoney(sellPrice)
            cb(true)
        else
            cb(false)
        end
    end)
end)

ESX.RegisterServerCallback('t1ger_garage:plyGarageStore',function(source, cb, id, val, vehProps, vehFuel)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate, fuel, vehicle = vehProps.plate, vehFuel, json.encode(vehProps)
    
    local vehSlots = 10
    if Config.PrivateGarages[id].prop == 'garage_small' then
        vehSlots = 2
    elseif Config.PrivateGarages[id].prop == 'garage_medium' then
        vehSlots = 6
    else
        vehSlots = 10
    end

    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner and plate = @plate",{['@owner'] = xPlayer.getIdentifier(), ['@plate'] = plate}, function(foundVeh)
        if #foundVeh > 0 then
            MySQL.Async.fetchAll("SELECT * FROM t1ger_garage WHERE garageID = @garageID",{['@garageID'] = id}, function(results)
                for k,v in pairs(results) do
                    local carList = json.decode(v.vehicles)
                    local emptySpot = false
                    for y,l in pairs(carList) do
                        if y > vehSlots then
                            emptySpot = false
                            break
                        end
                        if plate ~= l.plate and foundVeh[1].garage ~= "private" then
                            if l.plate == false then
                                l.plate = plate
                                MySQL.Sync.execute("UPDATE t1ger_garage SET vehicles = @vehicles WHERE garageID = @garageID", {
                                    ['@vehicles'] = json.encode(carList),
                                    ['@garageID'] = id
                                })
                                emptySpot = true
                                for _,j in pairs(foundVeh) do
                                    MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle = @vehicle, garage = @garage, fuel = @fuel, state = @state WHERE owner = @identifier AND plate = @plate", {
                                        ['@vehicle'] = vehicle,
                                        ['@identifier'] = xPlayer.getIdentifier(),
                                        ['@plate'] = plate,
                                        ['@garage'] = "private",
                                        ['@fuel'] = fuel,
                                        ['@state'] = 1
                                    })
                                end
                                cb(1)
                                break
                            end
                        else
                            emptySpot = true
                            for _,j in pairs(foundVeh) do
                                MySQL.Sync.execute("UPDATE owned_vehicles SET vehicle = @vehicle, garage = @garage, fuel = @fuel, state = @state WHERE owner = @identifier AND plate = @plate", {
                                    ['@vehicle'] = vehicle,
                                    ['@identifier'] = xPlayer.getIdentifier(),
                                    ['@plate'] = plate,
                                    ['@garage'] = "private",
                                    ['@fuel'] = fuel,
                                    ['@state'] = 1
                                })
                            end
                            cb(1)
                            break
                        end
                    end
                    if not emptySpot then
                        cb(0)
                    end
                end
            end)
        else
            cb(2)
        end
    end)
end)

RegisterServerEvent('t1ger_garage:spawnGarageSV')
AddEventHandler('t1ger_garage:spawnGarageSV', function(id, delCar)
    local xPlayer = ESX.GetPlayerFromId(source)
    local vehArray = {}
    local LoopDone = false
    MySQL.Async.fetchAll("SELECT * FROM t1ger_garage WHERE garageID = @garageID",{['@garageID'] = id}, function(data)
        for k,v in pairs(data) do
            local carList = json.decode(v.vehicles)
            for y,l in pairs(carList) do
                MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND plate=@plate",{['@identifier'] = xPlayer.getIdentifier(),['@plate'] = l.plate}, function(foundCar)
                    if #foundCar > 0 then
                        if l.plate == foundCar[1].plate then
                            local carState = foundCar[1].state
                            if carState == true then
                                local vehicle = json.decode(foundCar[1].vehicle)
                                table.insert(vehArray,{slot = y, plate = foundCar[1].plate, vehicle = vehicle, fuel = foundCar[1].fuel})
                            end
                        end
                    end
                    LoopDone = true
                end)
            end
        end
    end)

    while not LoopDone do
        Citizen.Wait(1)
    end

    if LoopDone then
        for k,v in pairs(Config.GarageSpawns) do
            if not v.inUse then
                TriggerClientEvent('t1ger_garage:spawnGarageCL', xPlayer.source, v.pos, id, vehArray, delCar)
                table.insert(takenSpawn,{player = xPlayer.getIdentifier(), garageID = id, spawn = k})
                v.inUse = true
                return
            end
        end
    end
end)

RegisterServerEvent('t1ger_garage:leaveGarageInVehSV')
AddEventHandler('t1ger_garage:leaveGarageInVehSV', function(id, plate, delVehicle)
    local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner=@identifier AND plate = @plate",{['@identifier'] = xPlayer.getIdentifier(), ['@plate'] = plate}, function(results) 
        local curVeh = {}
        for k,v in pairs(results) do
			local vehicle = json.decode(v.vehicle)
			table.insert(curVeh,{vehicle = vehicle, plate = v.plate, fuel = v.fuel})
		end
        for j,ply in pairs (takenSpawn) do 
            if xPlayer.getIdentifier() == ply.player then
                Config.GarageSpawns[ply.spawn].inUse = false
                break
            end
        end
        TriggerClientEvent('t1ger_garage:leaveGarageWithVehCL', xPlayer.source, id, curVeh, delVehicle)
	end)
end)

RegisterServerEvent('t1ger_garage:delVehFromPlyGarage')
AddEventHandler('t1ger_garage:delVehFromPlyGarage', function(id, val)
    local xPlayer = ESX.GetPlayerFromId(source)
    local plate, fuel = val.plate, val.fuel

    MySQL.Async.fetchAll("SELECT * FROM owned_vehicles WHERE owner = @owner and plate = @plate",{['@owner'] = xPlayer.getIdentifier(), ['@plate'] = plate}, function(foundVeh)
        if #foundVeh > 0 then
            MySQL.Async.fetchAll("SELECT * FROM t1ger_garage WHERE garageID = @garageID",{['@garageID'] = id}, function(results)
                for k,v in pairs(results) do
                    local carList = json.decode(v.vehicles)
                    for y,l in pairs(carList) do
                        if l.plate == plate then
                            l.plate = false
                            MySQL.Sync.execute("UPDATE t1ger_garage SET vehicles = @vehicles WHERE garageID = @garageID", {
                                ['@vehicles'] = json.encode(carList),
                                ['@garageID'] = id
                            })
                            MySQL.Sync.execute("UPDATE owned_vehicles SET garage = @garage WHERE plate = @plate AND owner = @owner", {
                                ['@owner'] = xPlayer.getIdentifier(),
                                ['@garage'] = NULL,
                                ['@plate'] = plate
                            })
                            break
                        end
                    end
                end
            end)
        end
    end)

end)
  --[[  
██╗░░░██╗██████╗░██╗░░░░░███████╗░█████╗░██╗░░██╗░██████╗
██║░░░██║██╔══██╗██║░░░░░██╔════╝██╔══██╗██║░██╔╝██╔════╝
██║░░░██║██████╔╝██║░░░░░█████╗░░███████║█████═╝░╚█████╗░
██║░░░██║██╔═══╝░██║░░░░░██╔══╝░░██╔══██║██╔═██╗░░╚═══██╗
╚██████╔╝██║░░░░░███████╗███████╗██║░░██║██║░╚██╗██████╔╝
░╚═════╝░╚═╝░░░░░╚══════╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░
█████████████████████████████████████████████████████████
discord.gg/6CRxjqZJFB ]]--