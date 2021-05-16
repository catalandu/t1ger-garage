# T1GER GARAGE

### Contact
Author: T1GER#9080
Discord: https://discord.gg/FdHkq5q 

### Requirements
- NOTHING! :)

### Installation
1) Drag & drop the folder into your `resources` server folder.
2) Configure the config file to your liking.
3) Import the SQL file into your database.
4) Add `start t1ger_garage` to your server config.
5) Make sure to read through the README!!!!

### Showcase
- https://streamable.com/9tnogf

### Protection
Do not touch or delete the protection folder. This is security. Upon deleting/corruption these, script will not work.

### Applying fuel on vehicle spawn:

The following guide will ensure that fuel is applied to the spawned vehicle from garage/impound etc.

1. Go to config.lua and find the config option called: "Config.HasFuelEvent"
2. Set this to either true/false depending on whether u have an even in your fueling script that adds fuel. Mine looks like this: "TriggerEvent("fuel:setFuel", car, fuelLevel)"
3. Next, go to client.lua and find the function called "SpawnSelectedVeh(vehicle,garage)". 
4. In this function, find the config option called "Config.HasFuelEvent".
5. In here, you change the TriggerEvent, to whatever Event is used in your fueling script. 

### Save Damage in ESX VehicleProps Instructions:

The following guide will help you to ensure that body & engine health, doors, windows and tires are saved in ESX Vehicle Properties correctly.
This is a better way of storing and fetching that kind of data. 

1. Go to es_extended/client/functions.lua
2. Find the function called: "ESX.Game.GetVehicleProperties = function(vehicle)" (should be on line 647 ish, if u havent changed too much, otherwise search for it)
3. Add this piece of code in that function in the top under the other local variables:

        local tyres = {}
        tyres[1] = {burst = IsVehicleTyreBurst(vehicle, 0, false), id = 0}
        tyres[2] = {burst = IsVehicleTyreBurst(vehicle, 1, false), id = 1}
        tyres[3] = {burst = IsVehicleTyreBurst(vehicle, 4, false), id = 4}
        tyres[4] = {burst = IsVehicleTyreBurst(vehicle, 5, false), id = 5}

        local doors = {}
        for i = 0, 5, 1 do
            doors[tostring(i)] = IsVehicleDoorDamaged(vehicle, i)
        end

        local windows = {}
        for i = 0, 13 do
            windows[tostring(i)] = IsVehicleWindowIntact(vehicle, i)
        end

// Example image: https://gyazo.com/8e0ca386eb517331de20327874c5983c

4. Go to the bottom of that very same function, inside the "return". You should see modTank, modWindows etc etc. 
5. Under one those, you add this:

        engine 			  =	GetVehicleEngineHealth(vehicle),
		body 			  = GetVehicleBodyHealth(vehicle),
		tyres			  = tyres,
		doors			  = doors,
		windows 		  = windows

// Example image: https://gyazo.com/ab06dad4624ceecc7cbfbb42149fe0d2

6. Make sure to add , on the mod before engine, otherwise your es_extended script will cry like a baby xD
7. Next, find the function called "ESX.Game.SetVehicleProperties = function(vehicle, props)". Should be the function right under the function you've just edited.
8. Scroll down to the bottom, before the last "end" that wraps the whole function and add this:

        if props.engine ~= nil then
            if props.engine < 980 then
                if props.engine < 400 then 
                    SetVehicleEngineHealth(vehicle, 400.0)
                else
                    SetVehicleEngineHealth(vehicle, tonumber(props.engine))
                end
            end	
        end

        if props.body ~= nil then
            if props.body < 980 then
                if props.body < 400 then 
                    SetVehicleBodyHealth(vehicle, 400.0)
                else
                    SetVehicleBodyHealth(vehicle, tonumber(props.body))
                end
            end	
        end

        if props.tyres ~= nil then
            for i,tyre in pairs(props.tyres) do
                if tyre.burst then
                    SetVehicleTyreBurst(vehicle, tyre.id, 0, 1000.0)
                end
            end
        end

        if props.doors ~= nil then
            for i,door in pairs(props.doors) do
                if door then
                    SetVehicleDoorBroken(vehicle, tonumber(i), true)
                end
            end
        end

        if props.windows ~= nil then
            for i,window in pairs(props.windows) do
                if window == false then
                    SmashVehicleWindow(vehicle, tonumber(i))
                end
            end
        end

// Example image #1: https://gyazo.com/c97e86e0a4305c8170c79e17c665a38f
// Example image #2: https://gyazo.com/b0069ad8f501c13b12bf511f970f1b2b

9. That's it. You've successfully added damage (engine, body, doors, windows and tires) to ESX Vehicle Properties, so it will automatically load these when vehicle is spawned using that.
10. Also I've set some values for engine health, body health, wheels etc., feel free to change them as you please. 
11. EXTRA: pastebin of my versions (complete full functions) of those two functions, in case you still don't understand how it works: https://pastebin.com/E7aDAN2R

### Impounding Vehicles

The following guide will help you to ensure that impounded vehicles are saved in database correctly.

1. Find the functions/events where you impound vehicles in whatever scripts yo uhave.
2. On the very top inside that function/event, you call this event:

        TriggerEvent('t1ger_garage:impoundVehicleData')

3. This will make sure, that whenever a vehicle is impounded, fuel and vehicle properties are saved in database too. This also sets the vehicle garage to "impound". 

EXAMPLE:

    RegisterNetEvent('bla:blablabla')
    AddEventHandler('bla:blablabla', function()
        TriggerEvent('t1ger_garage:impoundVehicleData')
        bla bla bla 
        bla bla 
        bla bla bla bla 
    end)

-- Taking out vehicle from impound:
Keep ind mind, when u take out a vehicle from impound, the garage is set to NULL, which means vehicle isn't saved in any garages, so it can be taken from anywhere, until vehicle is parked in a garage.
You can set it to a specific garage by changing NULL to a garage label from config. Do this in server.lua inside the callback called: 't1ger_garage:getImpoundFees' at the SQL call.
MySQL.Sync.execute("UPDATE owned_vehicles SET garage = NULL WHERE plate = @plate AND owner = @owner",{['@plate'] = plate, ['@owner'] = xPlayer.getIdentifier()})
This is however, not necessary, as players would park their car in a garage sooner or later - no matter what. 

### Police Impound

The following guide will help you to ensure that seized vehicles are saved in the police impound correctly.

1. Drive the vehicle to one of the police impounds
2. If the vehicle is stored in owned_vehicles table in database, then vehicle can be seized, otherwise not.
3. To release a vehicle, go to one of the police impound, click on the vehicle you wish to release and the vehicle will spawn.

This is a great RP feature, so do not hesitate to use it. There is no time-limit etc on seized vehicles, so this is something that should be defined 
in your server rules or in a server law/constitution. 

### Private Garages Q/A

[Q] How many garages can a player own?
[A] Players can purchase up to one private garage, no more than one.

[Q] What happens to the vehicle taken out from a private garage?
[A] Once a player leaves a private garage with a vehicle, the vehicle is immediately deleted from the private garage and garage is set to NULL, meaning if the car is lost/despawned and/or if player relogs, he can take the car from one of the public garages and not the private garages. This is to prevent bugabusing and duplicating multiple of the same vehicles. 

[Q] Can I add more private garage spots?
[A] Yes. Do this in Config.PrivateGarages. Make sure to do exactly as I've done.

[Q] Can I add new garage shells?
[A] Yes. Keep in mind that you need to follow the exact steps I've done for the existing shells. You also need to add offset etc for the garage. I'd recommend making a suggestion on my discord if u want support for more shells, I might include it. 




