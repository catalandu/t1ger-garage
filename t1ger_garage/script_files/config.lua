-------------------------------------
------- Created by T1GER#9080 -------
------- Cracked by UpLeaks ---------
-------------------------------------

Config = {}

Config.HasFuelEvent 		= true		-- set to false if you do not have an event in your fueling script, that adds fuel.
Config.ImpoundFees 			= 500		-- set impound fees to get vehicle from impound
Config.PayImpoundWithCash 	= true		-- set to false, to pay with bank money.

Config.Garages = {
	[1] = {
		label = "1",
		pos = {212.86,-797.53,30.87},
		heading = 338.93,
		blip = {enable = true, sprite = 357, display = 4, scale = 0.65, color = 3, name = "Garage"},
		marker = {enable = true, drawDist = 10.0, type = 20, scale = {x = 0.7, y = 0.7, z = 0.7}, color = {r = 240, g = 52, b = 52, a = 100}},
	},
	[2] = {
		label = "t1ger",
		pos = {45.12,-850.25,30.77},
		heading = 158.25,
		blip = {enable = true, sprite = 357, display = 4, scale = 0.65, color = 3, name = "Garage"},
		marker = {enable = true, drawDist = 10.0, type = 20, scale = {x = 0.7, y = 0.7, z = 0.7}, color = {r = 240, g = 52, b = 52, a = 100}},
	},
	[3] = {
		label = "D",
		pos = {108.79,-1070.66,29.22},
		heading = 261.72,
		blip = {enable = true, sprite = 357, display = 4, scale = 0.65, color = 3, name = "Garage"},
		marker = {enable = true, drawDist = 10.0, type = 20, scale = {x = 0.7, y = 0.7, z = 0.7}, color = {r = 240, g = 52, b = 52, a = 100}},
	},
	[4] = {
		label = "impound",	-- dont touch the label!
		pos = {410.02,-1638.29,29.29},
		heading = 5.94,
		blip = {enable = true, sprite = 68, display = 4, scale = 0.65, color = 7, name = "Impound"},
		marker = {enable = true, drawDist = 10.0, type = 20, scale = {x = 0.7, y = 0.7, z = 0.7}, color = {r = 240, g = 52, b = 52, a = 100}},
	},
	[5] = {
		label = "impound",	-- dont touch the label!
		pos = {1277.19,3627.9,33.04},
		heading = 14.36,
		blip = {enable = true, sprite = 68, display = 4, scale = 0.65, color = 7, name = "Impound"},
		marker = {enable = true, drawDist = 10.0, type = 20, scale = {x = 0.7, y = 0.7, z = 0.7}, color = {r = 240, g = 52, b = 52, a = 100}},
	},
	[6] = {
		label = "police",	-- dont touch the label!
		pos = {-1068.96,-853.88,4.87},
		heading = 22.52,
		blip = {enable = true, sprite = 68, display = 4, scale = 0.65, color = 38, name = "Police Impound"},
		marker = {enable = true, drawDist = 10.0, type = 20, scale = {x = 0.7, y = 0.7, z = 0.7}, color = {r = 240, g = 52, b = 52, a = 100}},
	},
	[7] = {
		label = "police",	-- dont touch the label!
		pos = {433.69,-1014.52,28.78},
		heading = 352.84,
		blip = {enable = true, sprite = 68, display = 4, scale = 0.65, color = 38, name = "Police Impound"},
		marker = {enable = true, drawDist = 10.0, type = 20, scale = {x = 0.7, y = 0.7, z = 0.7}, color = {r = 240, g = 52, b = 52, a = 100}},
	},
}

-- ## PRIVATE GARAGES ## --

Config.EnablePrivateGarages 	= true		-- REQUIRES K4MB1 Garage shells | set this to false to disable private garages
Config.PayGarageWithCash 		= true		-- Set to false to use bank money instead
Config.OwnedGarageBlip 			= true		-- Blip for owned garage (source player)
Config.PlayerGarageBlip 		= true		-- Blip to view other players' owned garages
Config.PurchasableGarageBlip 	= true		-- Blip to show garages forsale

-- Blip Settings for ALL private garages:
Config.PvtGarageBlip = {
	enable = true,
	sprite = 357,
	display = 4,
	scale = 0.65,
	color = 3
} 

-- Marker settings for ALL private garages:
Config.PvtGarageMarker = {
	enable = true,
	drawDist = 10.0,
	type = 20,
	scale = {x = 0.7, y = 0.7, z = 0.7},
	color = {r = 240, g = 52, b = 52, a = 100}
}

-- Defined shell props // do not touch this if you dont know what u are doing
Config.GarageShells = {
	['garage_small'] = `shell_garages`, 
	['garage_medium'] = `shell_garagem`, 
	['garage_large'] = `shell_garagel`, 
}

-- Garage coords around the map. Feel free to add as many as you wish :)
Config.PrivateGarages = {
	[1] = { pos = {-811.01,806.07,202.18}, h = 19.92, prop = 'garage_medium', price = 10000 },
	[2] = { pos = {-851.28,788.69,191.73}, h = 188.51, prop = 'garage_medium', price = 10000 },
	[3] = { pos = {-904.57,781.17,186.32}, h = 189.47, prop = 'garage_large', price = 20000 },
	[4] = { pos = {-956.73,802.04,177.72}, h = 1.8, prop = 'garage_large', price = 20000 },
	[5] = { pos = {-1002.26,784.79,171.46}, h = 112.48, prop = 'garage_large', price = 20000 },
	[6] = { pos = {-964.82,763.23,175.43}, h = 227.8, prop = 'garage_small', price = 5000 }
}

-- Offset spots relative to the spawned shell. Do not mess with this, if you don't know what u are doing. Read more about offsets here: https://runtime.fivem.net/doc/natives/?_0x1899F328B0E12848
Config.Offsets = {
	['garage_small'] = {
		entrance = {0.0, -5.0, 0.0-0.975},
		heading = 1.39,
		veh = {
			[1] = {pos = {2.0, 0.0, 0.0}, heading = 181.59},
			[2] = {pos = {-2.0, 0.0, 0.0}, heading = 181.59},
		},
	},
	['garage_medium'] = {
		entrance = {0.0, -7.0, 0.0-0.975},
		heading = 0.67,
		veh = {
			[1] = {pos = {-4.97, -3.24, 0.0}, heading = 0.86},
			[2] = {pos = {0.0, -3.24, 0.0}, heading = 0.86},
			[3] = {pos = {4.97, -3.24, 0.0}, heading = 0.86},
			[4] = {pos = {-4.97, 3.24, 0.0}, heading = 180.0},
			[5] = {pos = {0.0, 3.24, 0.0}, heading = 180.0},
			[6] = {pos = {4.97, 3.24, 0.0}, heading = 180.0},
		},
	},
	['garage_large'] = {
		entrance = {0.0, -16.31, 0.0-0.975},
		heading = 0.55,
		veh = {
			[1] = {pos = {4.77, -10.0, 0.0}, heading = 91.0},
			[2] = {pos = {4.77, -5.5, 0.0}, heading = 91.0},
			[3] = {pos = {4.77, -1.0, 0.0}, heading = 91.0},
			[4] = {pos = {4.77, 3.5, 0.0}, heading = 91.0},
			[5] = {pos = {4.77, 8.0, 0.0}, heading = 91.0},
			[6] = {pos = {-4.77, -10.0, 0.0}, heading = 272.26},
			[7] = {pos = {-4.77, -5.5, 0.0}, heading = 272.26},
			[8] = {pos = {-4.77, -1.0, 0.0}, heading = 272.26},
			[9] = {pos = {-4.77, 3.5, 0.0}, heading = 272.26},
			[10] = {pos = {-4.77, 8.0, 0.0}, heading = 272.26},
		},
	},
}

-- Predefined spawn spots for garages. Do not touch this, unless you know what u are messing with. 
Config.GarageSpawns = {
	[1] = { pos = {620.0,1000.0,-100.0}, inUse = false },
	[2] = { pos = {700.0,1000.0,-100.0}, inUse = false },
	[3] = { pos = {760.0,1000.0,-100.0}, inUse = false },
	[4] = { pos = {820.0,1000.0,-100.0}, inUse = false },
	[5] = { pos = {880.0,1000.0,-100.0}, inUse = false },
	[6] = { pos = {940.0,1000.0,-100.0}, inUse = false },
	[7] = { pos = {1000.0,1000.0,-100.0}, inUse = false },
	[8] = { pos = {1060.0,1000.0,-100.0}, inUse = false },
	[9] = { pos = {1120.0,1000.0,-100.0}, inUse = false },
	[10] = { pos = {1180.0,1000.0,-100.0}, inUse = false },
	[11] = { pos = {1240.0,1000.0,-100.0}, inUse = false },
	[12] = { pos = {1300.0,1000.0,-100.0}, inUse = false },
	[13] = { pos = {1360.0,1000.0,-100.0}, inUse = false },
	[14] = { pos = {1420.0,1000.0,-100.0}, inUse = false },
	[15] = { pos = {1480.0,1000.0,-100.0}, inUse = false },
	[16] = { pos = {1540.0,1000.0,-100.0}, inUse = false },
	[17] = { pos = {1600.0,1000.0,-100.0}, inUse = false },
	[18] = { pos = {1660.0,1000.0,-100.0}, inUse = false },
	[19] = { pos = {1720.0,1000.0,-100.0}, inUse = false },
	[20] = { pos = {1780.0,1000.0,-100.0}, inUse = false },
	[21] = { pos = {1840.0,1000.0,-100.0}, inUse = false },
	[22] = { pos = {1900.0,1000.0,-100.0}, inUse = false },
	[23] = { pos = {1960.0,1000.0,-100.0}, inUse = false },
	[24] = { pos = {2020.0,1000.0,-100.0}, inUse = false },
	[25] = { pos = {2080.0,1000.0,-100.0}, inUse = false },
	[26] = { pos = {2140.0,1000.0,-100.0}, inUse = false },
	[27] = { pos = {2200.0,1000.0,-100.0}, inUse = false },
	[28] = { pos = {2260.0,1000.0,-100.0}, inUse = false },
	[29] = { pos = {2320.0,1000.0,-100.0}, inUse = false },
	[30] = { pos = {2380.0,1000.0,-100.0}, inUse = false },
	[31] = { pos = {620.0,1150.0,-100.0}, inUse = false },
	[32] = { pos = {700.0,1150.0,-100.0}, inUse = false },
	[33] = { pos = {760.0,1150.0,-100.0}, inUse = false },
	[34] = { pos = {820.0,1150.0,-100.0}, inUse = false },
	[35] = { pos = {880.0,1150.0,-100.0}, inUse = false },
	[36] = { pos = {940.0,1150.0,-100.0}, inUse = false },
	[37] = { pos = {1000.0,1150.0,-100.0}, inUse = false },
	[38] = { pos = {1060.0,1150.0,-100.0}, inUse = false },
	[39] = { pos = {1120.0,1150.0,-100.0}, inUse = false },
	[40] = { pos = {1180.0,1150.0,-100.0}, inUse = false },
	[41] = { pos = {1240.0,1150.0,-100.0}, inUse = false },
	[42] = { pos = {1300.0,1150.0,-100.0}, inUse = false },
	[43] = { pos = {1360.0,1150.0,-100.0}, inUse = false },
	[44] = { pos = {1420.0,1150.0,-100.0}, inUse = false },
	[45] = { pos = {1480.0,1150.0,-100.0}, inUse = false },
	[46] = { pos = {1540.0,1150.0,-100.0}, inUse = false },
	[47] = { pos = {1600.0,1150.0,-100.0}, inUse = false },
	[48] = { pos = {1660.0,1150.0,-100.0}, inUse = false },
	[49] = { pos = {1720.0,1150.0,-100.0}, inUse = false },
	[50] = { pos = {1780.0,1150.0,-100.0}, inUse = false },
	[51] = { pos = {1840.0,1150.0,-100.0}, inUse = false },
	[52] = { pos = {1900.0,1150.0,-100.0}, inUse = false },
	[53] = { pos = {1960.0,1150.0,-100.0}, inUse = false },
	[54] = { pos = {2020.0,1150.0,-100.0}, inUse = false },
	[55] = { pos = {2080.0,1150.0,-100.0}, inUse = false },
	[56] = { pos = {2140.0,1150.0,-100.0}, inUse = false },
	[57] = { pos = {2200.0,1150.0,-100.0}, inUse = false },
	[58] = { pos = {2260.0,1150.0,-100.0}, inUse = false },
	[59] = { pos = {2320.0,1150.0,-100.0}, inUse = false },
	[60] = { pos = {2380.0,1150.0,-100.0}, inUse = false },
}  --[[  
██╗░░░██╗██████╗░██╗░░░░░███████╗░█████╗░██╗░░██╗░██████╗
██║░░░██║██╔══██╗██║░░░░░██╔════╝██╔══██╗██║░██╔╝██╔════╝
██║░░░██║██████╔╝██║░░░░░█████╗░░███████║█████═╝░╚█████╗░
██║░░░██║██╔═══╝░██║░░░░░██╔══╝░░██╔══██║██╔═██╗░░╚═══██╗
╚██████╔╝██║░░░░░███████╗███████╗██║░░██║██║░╚██╗██████╔╝
░╚═════╝░╚═╝░░░░░╚══════╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░
█████████████████████████████████████████████████████████
discord.gg/6CRxjqZJFB ]]--