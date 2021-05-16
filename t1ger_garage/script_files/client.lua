-------------------------------------
------- Created by T1GER#9080 -------
------- Cracked by UpLeaks ---------
-------------------------------------

garage = nil
Citizen.CreateThread(function()
    while true do
		Citizen.Wait(1)
		local player = GetPlayerPed(-1)
		local coords =  GetEntityCoords(player)
		for k,v in pairs(Config.Garages) do
			local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.pos[1], v.pos[2], v.pos[3], false)
			if garage ~= nil then
				distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, garage.pos[1], garage.pos[2], garage.pos[3], false)
				while garage ~= nil and distance > 2.0 do
					garage = nil
					Citizen.Wait(1)
				end
				if garage == nil then
					ESX.UI.Menu.CloseAll()
				end
			else
				local mk = v.marker
				if distance <= 10.0 and distance >= 2.0 then
					DrawMarker(mk.type, v.pos[1], v.pos[2], v.pos[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
				elseif distance <= 2.0 then
					if v.label == "impound" then
						DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], Lang['impound_draw_txt'])
						if IsControlJustPressed(0, 38) then
							garage = v
							OpenImpoundMenu(v)
						end
					elseif v.label == "police" then
						if PlayerData.job ~= nil and PlayerData.job.name == "police" then
							DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], Lang['pol_impound_draw_txt'])
							if IsControlJustPressed(0, 38) then
								garage = v
								if GetVehiclePedIsIn(player, false) > 0 then
									OpenPoliceSeizeMenu(v)
								else
									OpenPoliceImpoundVehList(v)
								end
							end
						end
					else
						DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], Lang['garage_draw_txt'])
						if IsControlJustPressed(0, 38) then
							garage = v
							OpenGarageMenu(v)
						end
					end
				end
			end
        end
    end
end)

function OpenGarageMenu(v)
	local playerPed  = GetPlayerPed(-1)
	local elements = {
		{ label = Lang['get_veh_from_garage'], value = "get_vehicle" },
		{ label = Lang['store_veh_to_garage'], value = "store_vehicle" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "garage_main_menu",
		{
			title    = "Garage: "..tostring(v.label),
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'get_vehicle') then
			OpenGarageVehList(v)
			menu.close()
			garage = nil
		end
		if(data.current.value == 'store_vehicle') then
			StoreVehicleInGarage(v)
			menu.close()
			garage = nil
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		garage = nil
	end)
end

function OpenGarageVehList(garage)
	local playerPed = GetPlayerPed(-1)
	local elements = {}
	ESX.TriggerServerCallback('t1ger_garage:fetchVehicles', function(vehList)
		for k,v in pairs(vehList) do
			local vehHash 	= v.vehicle.model
			local vehName 	= GetDisplayNameFromVehicleModel(vehHash)
			local vehLabel 	= GetLabelText(vehName)
			table.insert(elements,{label = vehLabel.." ["..v.plate.."]", name = vehLabel, value = v, plate = v.plate, fuel = v.fuel, vehicle = v.vehicle})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "garage_vehicle_list",
			{
				title    = "Garage : "..tostring(garage.label),
				align    = "center",
				elements = elements
			},
		function(data, menu)
			OpenVehicleInfoDisplay(data.current,garage)
			menu.close()
			--garage = nil
		end, function(data, menu)
			menu.close()
			garage = nil
		end)
	end, garage.label)
end

function OpenVehicleInfoDisplay(info,garage)
	local playerPed = GetPlayerPed(-1)
	local elements = {
		{ label = "Spawn Vehicle", value = info.value },
		--{ label = "% | Engine: ", value = nil, fuel = info.fuel, engine = info.vehicle.engine },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "garage_vehicle_info_display",
		{
			title    = ""..info.name.." ["..info.plate.."]",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if data.current.value ~= nil then
			if not IsPedInAnyVehicle(playerPed,false) then
				SpawnSelectedVeh(data.current.value,garage)
				menu.close()
				garage = nil
			else
				ShowNotifyESX(Lang['not_inside_vehicle'])
			end
		end
	end, function(data, menu)
		menu.close()
		OpenGarageVehList(garage)
	end)
end

function StoreVehicleInGarage(garage)
	local player = GetPlayerPed(-1)
	local curVeh = GetVehiclePedIsIn(player, false)
	local vehProps = ESX.Game.GetVehicleProperties(curVeh)
	local fuel = GetVehicleFuelLevel(curVeh)
	if curVeh > 0 then
		ESX.TriggerServerCallback('t1ger_garage:storeVehicle',function(ownedVehicle)
			if ownedVehicle then
				DeleteVehicle(curVeh)
				TriggerServerEvent('t1ger_garage:updateState', vehProps.plate, true)
				ShowNotifyESX(Lang['vehicle_stored'])
			else
				ShowNotifyESX(Lang['not_owned_veh'])
			end
		end, garage.label, vehProps, fuel)
	else
		ShowNotifyESX(Lang['not_in_vehicle'])
	end
end

function OpenImpoundMenu(garage)
	local playerPed = GetPlayerPed(-1)
	local elements = {}
	ESX.TriggerServerCallback('t1ger_garage:fetchImpoundedVehicles', function(impoundVehList)
		for k,v in pairs(impoundVehList) do
			local vehHash 	= v.vehicle.model
			local vehName 	= GetDisplayNameFromVehicleModel(vehHash)
			local vehLabel 	= GetLabelText(vehName)
			local impoundPrice = tonumber(Config.ImpoundFees)
			table.insert(elements,{label = vehLabel.." [$"..impoundPrice.."]", value = v})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "impound_vehicle_list",
			{
				title    = "Impound",
				align    = "center",
				elements = elements
			},
		function(data, menu)
			ESX.TriggerServerCallback('t1ger_garage:getImpoundFees', function(feesPaid)
				if feesPaid then
					ShowNotifyESX(Lang['impound_fees_paid'])
					SpawnSelectedVeh(data.current.value,garage)
					menu.close()
					garage = nil
				else
					ShowNotifyESX(Lang['not_enough_money'])
					menu.close()
					garage = nil
				end
			end, data.current.value.plate)
		end, function(data, menu)
			menu.close()
			garage = nil
		end)
	end, garage.label)
end

function OpenPoliceImpoundVehList(garage)
	local playerPed = GetPlayerPed(-1)
	local elements = {}
	ESX.TriggerServerCallback('t1ger_garage:fetchSeizedVehicles', function(seizedVehList)
		for k,v in pairs(seizedVehList) do
			local vehHash 	= v.vehicle.model
			local vehName 	= GetDisplayNameFromVehicleModel(vehHash)
			local vehLabel 	= GetLabelText(vehName)
			table.insert(elements,{label = vehLabel.." ["..v.plate.."]", value = v})
		end
		ESX.UI.Menu.Open('default', GetCurrentResourceName(), "seized_vehicle_list",
			{
				title    = "Police Impound",
				align    = "center",
				elements = elements
			},
		function(data, menu)
			if GetVehiclePedIsIn(playerPed, false) > 0 then
				ShowNotifyESX(Lang['not_inside_vehicle'])
			else
				SpawnSelectedVeh(data.current.value,garage)
				menu.close()
				garage = nil
			end
		end, function(data, menu)
			menu.close()
			garage = nil
		end)
	end, garage.label)
end

function OpenPoliceSeizeMenu(v)
	local playerPed  = GetPlayerPed(-1)
	local elements = {
		{ label = "Seize Vehicle", value = "seize_vehicle" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "garage_main_menu",
		{
			title    = "Police Impound",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'seize_vehicle') then
			SeizeVehicleFunction(v)
			menu.close()
			garage = nil
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		garage = nil
	end)
end

function SeizeVehicleFunction(garage)
	local player = GetPlayerPed(-1)
	local seizeCar = GetVehiclePedIsIn(player, false)
	local vehProps = ESX.Game.GetVehicleProperties(seizeCar)
	local fuel = GetVehicleFuelLevel(seizeCar)

	if seizeCar > 0 then
		ESX.TriggerServerCallback('t1ger_garage:seizeVehicle',function(plateValid)
			if plateValid then
				DeleteVehicle(seizeCar)
				ShowNotifyESX((Lang['vehicle_seized']):format(vehProps.plate))
			else
				ShowNotifyESX(Lang['plate_not_exists'])
			end
		end, garage.label, vehProps, fuel)
	else
		ShowNotifyESX(Lang['not_in_vehicle'])
	end
end

function SpawnSelectedVeh(vehicle,garage)
	ESX.Game.SpawnVehicle(vehicle.vehicle.model,{x = garage.pos[1], y = garage.pos[2], z = garage.pos[3] + 1}, garage.heading, function(car)
		ESX.Game.SetVehicleProperties(car, vehicle.vehicle)
		SetVehRadioStation(car, "OFF")
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), car, -1)
		local vehPlate = GetVehicleNumberPlateText(car):gsub("^%s*(.-)%s*$", "%1")
		--TriggerServerEvent("ls:mainCheck", vehPlate, car, true) -- IDK what this is used for, but I've seen it in many other garage scripts - use or don't.
		if garage.label == "police" then
			TriggerServerEvent('t1ger_garage:releaseSeizedVeh', vehPlate, false)
		else
			TriggerServerEvent('t1ger_garage:updateState', vehPlate, false)
		end
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

RegisterNetEvent('t1ger_garage:impoundVehicleCL')
AddEventHandler('t1ger_garage:impoundVehicleCL', function()
	ImpoundVehicleData()
end)

function ImpoundVehicleData()
	local plyPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(plyPed, true)
	local vehicle = nil

	if IsPedInAnyVehicle(plyPed, false) then
		vehicle = GetVehiclePedIsIn(plyPed, false)
	else
		vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 6.0, 0, 71)
	end

	local vehProps = ESX.Game.GetVehicleProperties(vehicle)
	local fuel = GetVehicleFuelLevel(vehicle)
	local label = "impound"

	if vehProps.plate ~= nil then
		TriggerServerEvent('t1ger_garage:impoundVehicleSV', vehProps, fuel, label)
	end
end


-- PRIVATE GARAGE:

local inGarage = false
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if inGarage then
            NetworkOverrideClockTime(23, 0, 0)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist('CLEAR')
            SetWeatherTypeNow('CLEAR')
            SetWeatherTypeNowPersist('CLEAR')
            SetRainFxIntensity(0.0)
        end
    end
end)

plyGarageID = 0
emptyGarage = {}

RegisterNetEvent('t1ger_garage:applyPlyGarage')
AddEventHandler('t1ger_garage:applyPlyGarage', function(garageID)
	plyGarageID = garageID

	for k,v in pairs(pvtBlips) do
		RemoveBlip(v)
	end

	ESX.TriggerServerCallback('t1ger_garage:getPurchasedGarages', function(takenGarages)
		for k,v in pairs(takenGarages) do
			if v.id ~= plyGarageID then
				emptyGarage[v.id] = v.id
			end
		end
		for k,v in pairs(Config.PrivateGarages) do
			if plyGarageID == k then
				if Config.OwnedGarageBlip then
					CreatePvtGarageBlip(k,v,"Your Garage")
				end
			else
				if emptyGarage[k] == k then
					if Config.PlayerGarageBlip then
						CreatePvtGarageBlip(k,v,"Player Garage")
					end
				else
					if Config.PurchasableGarageBlip then
						CreatePvtGarageBlip(k,v,"Purchasable Garage")
					end
				end
			end
		end
	end)
end)

plyGarage = nil
Citizen.CreateThread(function()
	if Config.EnablePrivateGarages then
		while true do
			Citizen.Wait(1)
			local player = GetPlayerPed(-1)
			local coords =  GetEntityCoords(player)
			for k,v in pairs(Config.PrivateGarages) do
				local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.pos[1], v.pos[2], v.pos[3], false)
				if plyGarage ~= nil then
					distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, plyGarage.pos[1], plyGarage.pos[2], plyGarage.pos[3], false)
					while plyGarage ~= nil and distance > 2.0 do
						plyGarage = nil
						Citizen.Wait(1)
					end
					if plyGarage == nil then
						ESX.UI.Menu.CloseAll()
					end
				else
					local mk = Config.PvtGarageMarker
					if distance <= 10.0 and distance >= 2.0 then
						if mk.enable then
							DrawMarker(mk.type, v.pos[1], v.pos[2], v.pos[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
						end
					elseif distance <= 2.0 then
						if plyGarageID == k then
							DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], "~r~[E]~s~ | GARAGE")
							if IsControlJustPressed(0, 38) then
								plyGarage = v
								OpenGarageManageMenu(k,v)
							end
						else
							if emptyGarage[k] == k then
								DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], "GARAGE OWNED BY SOMEONE ELSE")
							else
								if plyGarageID == 0 then
									DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], "~r~[E]~s~ BUY GARAGE ~g~[$"..math.floor(v.price).."]~s~")
									if IsControlJustPressed(0, 38) then
										plyGarage = v
										OpenGarageBuyMenu(k,v)
									end
								else
									DrawText3Ds(v.pos[1], v.pos[2], v.pos[3], "SELL YOUR GARAGE, THEN BUY THIS")
								end
							end
						end
					end
				end
			end
		end
	end
end)

function OpenGarageBuyMenu(id,val)
	local playerPed  = GetPlayerPed(-1)
	local elements = {
		{ label = "Yes", value = "confirm_purchase" },
		{ label = "No", value = "decline_purchase" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "pvt_garage_buy_confirmation",
		{
			title    = "Confirm | Price: $"..math.floor(val.price),
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'confirm_purchase') then
			ESX.TriggerServerCallback('t1ger_garage:purchaseGarage', function(purchased)
				if purchased then
					ShowNotifyESX((Lang['pvt_garage_purchased']):format(math.floor(val.price)))
					TriggerServerEvent('t1ger_garage:getPlyGarages')
				else
					ShowNotifyESX(Lang['not_enough_money'])
				end
			end, id, val)
			menu.close()
			plyGarage = nil
		end
		if(data.current.value == 'decline_purchase') then
			menu.close()
			plyGarage = nil
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		plyGarage = nil
	end)
end

function OpenGarageManageMenu(id,val)
	local playerPed  = GetPlayerPed(-1)
	local elements = {
		{ label = "Enter Garage", value = "enter_garage" },
		{ label = "Sell Garage", value = "sell_garage" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "pvt_garage_menu",
		{
			title    = "Garage: "..tostring(id),
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'enter_garage') then
			EnterGarageFunction(id, val)
			menu.close()
			plyGarage = nil
		end
		if(data.current.value == 'sell_garage') then
			SellPrivateGarage(id,val)
			menu.close()
			plyGarage = nil
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		plyGarage = nil
	end)
end

function SellPrivateGarage(id,val)
	local playerPed  = GetPlayerPed(-1)
	local sellPrice = (val.price * 0.75)
	local elements = {
		{ label = "Yes", value = "confirm_sale" },
		{ label = "No", value = "decline_sale" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "pvt_garage_sell_confirmation",
		{
			title    = "Confirm Sale | Price: $"..math.floor(sellPrice),
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'confirm_sale') then
			ESX.TriggerServerCallback('t1ger_garage:sellGarage', function(sold)
				if sold then
					TriggerServerEvent('t1ger_garage:getPlyGarages')
					ShowNotifyESX((Lang['pvt_garage_sold']):format(math.floor(sellPrice)))
				else
					ShowNotifyESX(Lang['not_ply_garage'])
				end
			end, id, val, math.floor(sellPrice))
			menu.close()
			plyGarage = nil
		end
		if(data.current.value == 'decline_sale') then
			menu.close()
			plyGarage = nil
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		plyGarage = nil
	end)
end

function EnterGarageFunction(id, val)
	local player = GetPlayerPed(-1)
	local curVeh = GetVehiclePedIsIn(player, false)
	local vehProps = ESX.Game.GetVehicleProperties(curVeh)
	local fuel = GetVehicleFuelLevel(curVeh)
	if curVeh > 0 then
		ESX.TriggerServerCallback('t1ger_garage:plyGarageStore',function(stored)
			if stored == 0 then
				ShowNotifyESX(Lang['no_empty_space'])
			elseif stored == 1 then
				TriggerServerEvent('t1ger_garage:spawnGarageSV', id, curVeh)
			elseif stored == 2 then
				ShowNotifyESX(Lang['not_owned_veh'])
			end
		end, id, val, vehProps, fuel)
	else
		TriggerServerEvent('t1ger_garage:spawnGarageSV', id, curVeh)
	end
end

SpawnedGarage = nil
SpawnedCars = {}
insideGarage = nil
RegisterNetEvent('t1ger_garage:spawnGarageCL')
AddEventHandler('t1ger_garage:spawnGarageCL', function(spawn, id, carsArray, deleteCar)
	local player = GetPlayerPed(-1)
	local coords = GetEntityCoords(player)

	-- Spawning the shell:
	local prop = Config.PrivateGarages[id].prop
	local shell = CreateObject(Config.GarageShells[prop], spawn[1], spawn[2], spawn[3], false)
	FreezeEntityPosition(shell, true)
	Wait(100)
	SpawnedGarage = shell
	inGarage = true

	-- Screen Fade Out/In:
	DoScreenFadeOut(800)
	while not IsScreenFadedOut() do
		Wait(0)
	end
	Citizen.Wait(250)

	if deleteCar > 0 then
		DeleteVehicle(deleteCar)
		ShowNotifyESX(Lang['vehicle_stored'])
	end

	local offset = Config.Offsets[prop]
	local entry = GetOffsetFromEntityInWorldCoords(shell, offset.entrance[1], offset.entrance[2], offset.entrance[3])
    SetEntityCoords(player, entry[1], entry[2], entry[3]-0.975)
    SetEntityHeading(player, offset.heading)
    Citizen.Wait(500)

	-- Spawning Cars:
	for _,array in pairs(carsArray) do
		for j,l in pairs(offset.veh) do
			if array.slot == j then
				local vehPos = GetOffsetFromEntityInWorldCoords(shell, l.pos[1], l.pos[2], l.pos[3])
				ESX.Game.SpawnVehicle(array.vehicle.model,{x = vehPos[1], y = vehPos[2], z = vehPos[3] + 1}, l.heading, function(car)
					ESX.Game.SetVehicleProperties(car, array.vehicle)
					SetVehRadioStation(car, "OFF")
					SetVehicleOnGroundProperly(car)
					SetVehicleUndriveable(car, true)
					local vehPlate = GetVehicleNumberPlateText(car):gsub("^%s*(.-)%s*$", "%1")
					TriggerServerEvent('t1ger_garage:updateState', vehPlate, true)
					ESX.TriggerServerCallback('t1ger_garage:getVehicleFuel', function(vehFuel)
						if vehFuel ~= nil then
							if Config.HasFuelEvent then
								TriggerEvent("fuel:setFuel", car, vehFuel)
							else
								SetVehicleFuelLevel(car, vehFuel + 0.0)
							end
						end
					end, vehPlate)
					table.insert(SpawnedCars,{slot = array.slot, vehicle = array.vehicle, plate = array.plate, fuel = array.fuel, pos = vehPos})
				end)
			end
		end
	end
	Citizen.Wait(200)
	DoScreenFadeIn(1250)

	-- Loop inside garage:
	while inGarage do
		Citizen.Wait(1)
		local player = GetPlayerPed(-1)
		local coords =  GetEntityCoords(player)

		local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, entry[1], entry[2], entry[3], false)
		if insideGarage ~= nil then
			distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, insideGarage[1], insideGarage[2], insideGarage[3], false)
			while insideGarage ~= nil and distance > 2.0 do
				insideGarage = nil
				Citizen.Wait(1)
			end
			if insideGarage == nil then
				ESX.UI.Menu.CloseAll()
			end
		else
			local mk = Config.PvtGarageMarker
			if distance <= 10.0 and distance >= 2.0 then
				DrawMarker(mk.type, entry[1], entry[2], entry[3], 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, mk.scale.x, mk.scale.y, mk.scale.z, mk.color.r, mk.color.g, mk.color.b, mk.color.a, false, true, 2, false, false, false, false)
			elseif distance <= 2.0 then
				DrawText3Ds(entry[1], entry[2], entry[3], Lang['garage_inside_draw_txt'])
				if IsControlJustPressed(0, 38) then
					insideGarage = entry
					OpenGarageMenuInside(id)
				end
			end
		end

		-- Loop for cars actions
		for k,v in pairs(SpawnedCars) do
			local distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, v.pos[1], v.pos[2], v.pos[3], false)
			if distance <= 2.5 then
				if GetEntityModel(GetVehiclePedIsIn(PlayerPedId())) == v.vehicle.model then
					Draw3DText(v.pos[1], v.pos[2], v.pos[3]-0.2, "~r~[E]~s~ | Take Vehicle Out")
					Draw3DText(v.pos[1], v.pos[2], v.pos[3]-0.3, "Fuel: "..round(v.fuel,1).."% | Engine: "..round(v.vehicle.engine,2))
					if IsControlJustPressed(0, 38) then
						local delVehicle = GetVehiclePedIsIn(player, false)
						TriggerServerEvent('t1ger_garage:leaveGarageInVehSV', id, v.plate, delVehicle)
						inGarage = false
					end
				end
			end
		end
	end
end)

function OpenGarageMenuInside(id)
	local playerPed  = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed)
	local elements = {
		{ label = "Leave Garage", value = "leave_garage" },
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "pvt_garage_inside_menu",
		{
			title    = "Private Garage",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'leave_garage') then
			TriggerServerEvent('t1ger_garage:leaveGarageSV', id)
			inGarage = false
			menu.close()
			insideGarage = nil
		end
		menu.close()
	end, function(data, menu)
		menu.close()
		insideGarage = nil
	end)
end

RegisterCommand('garages', function(source, args)
	print("command")
	ESX.TriggerServerCallback('t1ger_garage:getGarageList', function(vehList)
		for k,v in pairs(vehList) do
			print(v.garage)
			local label = ""
			if v.garage == nil then
				label = "[NULL]"
			else
				if v.garage == "police" then
					label = "[Seized] "
				elseif v.garage == "impound" then
					label = "[Impound] "
				else
					if v.garage == "private" then
						label = "[Private Garage] "
					else
						label = "[Garage "..v.garage.."] "
					end
				end
			end
			local vehName = GetDisplayNameFromVehicleModel(v.vehicle.model)
			label = label..vehName.." ("..v.plate..")"
			TriggerEvent('chat:addMessage', { args = { label } })
		end
	end)
end, false)

  --[[  
██╗░░░██╗██████╗░██╗░░░░░███████╗░█████╗░██╗░░██╗░██████╗
██║░░░██║██╔══██╗██║░░░░░██╔════╝██╔══██╗██║░██╔╝██╔════╝
██║░░░██║██████╔╝██║░░░░░█████╗░░███████║█████═╝░╚█████╗░
██║░░░██║██╔═══╝░██║░░░░░██╔══╝░░██╔══██║██╔═██╗░░╚═══██╗
╚██████╔╝██║░░░░░███████╗███████╗██║░░██║██║░╚██╗██████╔╝
░╚═════╝░╚═╝░░░░░╚══════╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░
█████████████████████████████████████████████████████████
discord.gg/6CRxjqZJFB ]]--