-------------------------------------
------- Created by T1GER#9080 -------
------- Cracked by UpLeaks ---------
-------------------------------------

RegisterNetEvent('t1ger_garage:leaveGarageCL')
AddEventHandler('t1ger_garage:leaveGarageCL', function(id)
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
    local exit = Config.PrivateGarages[id].pos
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    DeleteObject(SpawnedGarage)
    for _,z in pairs(SpawnedCars) do
        local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 30.0, z.vehicle.model, 71)
        DeleteVehicle(vehicle)
    end
    SetEntityCoords(player, exit[1], exit[2], exit[3]-0.975)
    Wait(500)
    DoScreenFadeIn(1250)
    SpawnedCars = {}
    SpawnedGarage = nil
end)

RegisterNetEvent('t1ger_garage:leaveGarageWithVehCL')
AddEventHandler('t1ger_garage:leaveGarageWithVehCL', function(id, spawnVeh, delVehicle)
    local player = GetPlayerPed(-1)
    local coords = GetEntityCoords(player)
    local plyVeh = spawnVeh
    local exit = Config.PrivateGarages[id].pos
    DoScreenFadeOut(800)
    while not IsScreenFadedOut() do
        Wait(0)
    end
    DeleteObject(SpawnedGarage)
    DeleteVehicle(delVehicle)
    for _,z in pairs(SpawnedCars) do
        local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 30.0, z.vehicle.model, 71)
        DeleteVehicle(vehicle)
    end
    SetEntityCoords(player, exit[1], exit[2], exit[3]-0.975)
    Wait(250)
    for k,v in pairs(spawnVeh) do
        ESX.Game.SpawnVehicle(v.vehicle.model,{x = exit[1], y = exit[2], z = exit[3] + 1}, Config.PrivateGarages[id].h, function(car)
            ESX.Game.SetVehicleProperties(car, v.vehicle)
            SetVehRadioStation(car, "OFF")
            SetVehicleEngineOn(car, true, true, false)
            SetVehicleOnGroundProperly(car)
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), car, -1)
            local vehPlate = GetVehicleNumberPlateText(car):gsub("^%s*(.-)%s*$", "%1")
            TriggerServerEvent('t1ger_garage:updateState', vehPlate, false)
            TriggerServerEvent('t1ger_garage:delVehFromPlyGarage', id, v)
            ESX.TriggerServerCallback('t1ger_garage:getVehicleFuel', function(vehFuel)
                if vehFuel ~= nil then
                    if Config.HasFuelEvent then
                        TriggerEvent("fuel:setFuel", car, vehFuel)
                    else
                        SetVehicleFuelLevel(car, vehFuel + 0.0)
                    end
                end
            end, vehPlate)
        end)
    end
    Wait(250)
    DoScreenFadeIn(1250)
    SpawnedCars = {}
    SpawnedGarage = nil
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