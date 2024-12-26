

-- Dump della struttura di tabella legacycore.lgf_jobs
CREATE TABLE IF NOT EXISTS `lgf_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `grade` int(11) DEFAULT NULL,
  `paycheck` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dump dei dati della tabella legacycore.lgf_jobs: ~10 rows (circa)
INSERT INTO `lgf_jobs` (`id`, `name`, `label`, `grade`, `paycheck`) VALUES
	(32, 'police', 'Police Officer', 1, 4000),
	(33, 'police', 'Peppe Impastato', 2, 2112121),
	(34, 'police', 'Detective', 3, 8000),
	(35, 'police', 'Sergeant', 4, 10000),
	(36, 'ambulance', 'Paramedic', 1, 3500),
	(37, 'ambulance', 'Senior Paramedic', 2, 5000),
	(38, 'ambulance', 'Chief Paramedic', 3, 7000),
	(39, 'ambulance', 'Medical Director', 4, 9000),
	(40, 'unemployed', 'Unemployed', 0, 500),
	(42, 'Mechanic', 'mechanic', 1, 1000);


-- Dump della struttura di tabella legacycore.lgf_society
CREATE TABLE IF NOT EXISTS `lgf_society` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `funds` int(11) NOT NULL,
  `shared` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dump dei dati della tabella legacycore.lgf_society: ~3 rows (circa)
INSERT INTO `lgf_society` (`id`, `name`, `funds`, `shared`) VALUES
	(5, 'police', 47878, 1),
	(7, 'ambulance', 5000, 1),
	(8, 'ems', 5000, 1);


-- Dump della struttura di tabella legacycore.outfits
CREATE TABLE IF NOT EXISTS `outfits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) NOT NULL,
  `name` longtext DEFAULT NULL,
  `ped` longtext DEFAULT NULL,
  `components` longtext DEFAULT NULL,
  `props` longtext DEFAULT NULL,
  `charIdentifier` longtext DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dump dei dati della tabella legacycore.outfits: ~3 rows (circa)
INSERT INTO `outfits` (`id`, `identifier`, `name`, `ped`, `components`, `props`, `charIdentifier`) VALUES
	(1, 'license:5c54fbccfc7d92223ebc3e63fec67771759a704a', 'Tutto fresco', '"mp_m_freemode_01"', '[{"component_id":0,"drawable":0,"texture":0},{"component_id":1,"drawable":16,"texture":0},{"component_id":2,"drawable":0,"texture":0},{"component_id":3,"drawable":0,"texture":0},{"component_id":4,"drawable":133,"texture":0},{"component_id":5,"drawable":2,"texture":0},{"component_id":6,"drawable":7,"texture":0},{"component_id":7,"drawable":0,"texture":0},{"component_id":8,"drawable":15,"texture":0},{"component_id":9,"drawable":0,"texture":0},{"component_id":10,"drawable":0,"texture":0},{"component_id":11,"drawable":76,"texture":0}]', '[{"prop_id":0,"drawable":-1,"texture":-1},{"prop_id":1,"drawable":-1,"texture":-1},{"prop_id":2,"drawable":-1,"texture":-1},{"prop_id":6,"drawable":-1,"texture":-1},{"prop_id":7,"drawable":-1,"texture":-1}]', '2'),
	(2, 'license:5c54fbccfc7d92223ebc3e63fec67771759a704a', 'gayo', '"mp_m_freemode_01"', '[{"drawable":0,"component_id":0,"texture":0},{"drawable":18,"component_id":1,"texture":0},{"drawable":0,"component_id":2,"texture":0},{"drawable":0,"component_id":3,"texture":0},{"drawable":136,"component_id":4,"texture":0},{"drawable":3,"component_id":5,"texture":0},{"drawable":7,"component_id":6,"texture":0},{"drawable":0,"component_id":7,"texture":0},{"drawable":15,"component_id":8,"texture":0},{"drawable":0,"component_id":9,"texture":0},{"drawable":0,"component_id":10,"texture":0},{"drawable":78,"component_id":11,"texture":0}]', '[{"drawable":-1,"texture":-1,"prop_id":0},{"drawable":-1,"texture":-1,"prop_id":1},{"drawable":-1,"texture":-1,"prop_id":2},{"drawable":-1,"texture":-1,"prop_id":6},{"drawable":-1,"texture":-1,"prop_id":7}]', '2'),
	(3, 'license:5c54fbccfc7d92223ebc3e63fec67771759a704a', 'gangsta', '"mp_m_freemode_01"', '[{"component_id":0,"drawable":0,"texture":0},{"component_id":1,"drawable":54,"texture":0},{"component_id":2,"drawable":0,"texture":0},{"component_id":3,"drawable":0,"texture":0},{"component_id":4,"drawable":132,"texture":0},{"component_id":5,"drawable":0,"texture":0},{"component_id":6,"drawable":1,"texture":0},{"component_id":7,"drawable":0,"texture":0},{"component_id":8,"drawable":0,"texture":0},{"component_id":9,"drawable":0,"texture":0},{"component_id":10,"drawable":0,"texture":0},{"component_id":11,"drawable":3,"texture":2}]', '[{"prop_id":0,"drawable":-1,"texture":-1},{"prop_id":1,"drawable":0,"texture":0},{"prop_id":2,"drawable":-1,"texture":-1},{"prop_id":6,"drawable":-1,"texture":-1},{"prop_id":7,"drawable":-1,"texture":-1}]', '1');

-- Dump della struttura di tabella legacycore.owned_vehicles
CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` longtext DEFAULT NULL,
  `plate` varchar(12) NOT NULL,
  `vehicle` longtext DEFAULT NULL,
  `type` varchar(20) NOT NULL DEFAULT 'car',
  `shared` longtext DEFAULT NULL,
  `stored` tinyint(4) NOT NULL DEFAULT 0,
  `garage` varchar(60) NOT NULL DEFAULT 'GARAGE A',
  `glovebox` longtext DEFAULT NULL,
  `trunk` longtext DEFAULT NULL,
  `parking` longtext NOT NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dump dei dati della tabella legacycore.owned_vehicles: ~2 rows (circa)
INSERT INTO `owned_vehicles` (`owner`, `plate`, `vehicle`, `type`, `shared`, `stored`, `garage`, `glovebox`, `trunk`, `parking`) VALUES
	('license:5c54fbccfc7d92223ebc3e63fec67771759a704a', '3TUMZHWH', '{"fuelLevel":65,"modSpoilers":-1,"modStruts":-1,"modCustomTiresF":false,"modBrakes":-1,"modXenon":false,"modFrontBumper":-1,"doors":[],"model":-1297672541,"wheelWidth":1.0,"modTrimA":-1,"modWindows":-1,"modLivery":-1,"paintType2":7,"modHorns":-1,"modHydrolic":-1,"windows":[0,1,3,4,5,6,7],"modCustomTiresR":false,"wheelColor":156,"paintType1":7,"modShifterLeavers":-1,"modTank":-1,"interiorColor":0,"modExhaust":-1,"modBackWheels":-1,"plateIndex":0,"modRoofLivery":-1,"tyres":[],"modAerials":-1,"extras":[],"modEngine":-1,"color2":0,"bulletProofTyres":true,"modHood":-1,"modDoorSpeaker":-1,"xenonColor":255,"modPlateHolder":-1,"modFrame":-1,"modDashboard":-1,"modRearBumper":-1,"modFrontWheels":-1,"modVanityPlate":-1,"color1":6,"modSpeakers":-1,"oilLevel":5,"modHydraulics":false,"modDial":-1,"modTransmission":-1,"tankHealth":985,"modNitrous":-1,"modSuspension":-1,"modLightbar":-1,"modArmor":-1,"modTrimB":-1,"neonEnabled":[false,false,false,false],"pearlescentColor":111,"wheels":7,"driftTyres":false,"dirtLevel":5,"modSeats":-1,"windowTint":-1,"engineHealth":950,"modAirFilter":-1,"dashboardColor":0,"modArchCover":-1,"modSmokeEnabled":false,"modSideSkirt":-1,"modRoof":-1,"tyreSmokeColor":[255,255,255],"modDoorR":-1,"modEngineBlock":-1,"modSteeringWheel":-1,"bodyHealth":891,"modRightFender":-1,"modAPlate":-1,"neonColor":[255,0,255],"wheelSize":1.0,"modGrille":-1,"modTrunk":-1,"plate":"3TUMZHWH","modTurbo":false,"modSubwoofer":-1,"modFender":-1,"modOrnaments":-1}', 'car', NULL, 0, 'GARAGE A', NULL, NULL, ''),
	('license:5c54fbccfc7d92223ebc3e63fec67771759a704a', '81JP4YFP', '{"windowTint":-1,"modFrontWheels":-1,"modHood":-1,"bulletProofTyres":true,"oilLevel":5,"fuelLevel":65,"modGrille":-1,"modEngineBlock":-1,"modSteeringWheel":-1,"modFrame":-1,"modDashboard":-1,"modShifterLeavers":-1,"plateIndex":0,"paintType2":7,"modStruts":-1,"tyreSmokeColor":[255,255,255],"modCustomTiresR":false,"modVanityPlate":-1,"paintType1":7,"wheelWidth":1.0,"modTrimA":-1,"xenonColor":255,"neonColor":[255,0,255],"modRearBumper":-1,"engineHealth":1000,"modSmokeEnabled":false,"modLightbar":-1,"bodyHealth":1000,"plate":"81JP4YFP","modDoorR":-1,"modDoorSpeaker":-1,"color1":69,"modSpeakers":-1,"extras":{"11":1,"12":0},"wheelColor":156,"modOrnaments":-1,"modSpoilers":-1,"dirtLevel":12,"pearlescentColor":74,"modWindows":-1,"modFrontBumper":-1,"modHydrolic":-1,"interiorColor":0,"modSideSkirt":-1,"modFender":-1,"modDial":-1,"modPlateHolder":-1,"modRightFender":-1,"modRoof":-1,"neonEnabled":[false,false,false,false],"tankHealth":1000,"driftTyres":false,"color2":0,"modRoofLivery":-1,"modAirFilter":-1,"modTransmission":-1,"modArchCover":-1,"modXenon":false,"modNitrous":-1,"modSuspension":-1,"windows":[4,5],"modCustomTiresF":false,"dashboardColor":0,"doors":[],"modAerials":-1,"modEngine":-1,"modAPlate":-1,"model":-1883869285,"modTrimB":-1,"tyres":[],"modBackWheels":-1,"wheels":0,"wheelSize":1.0,"modArmor":-1,"modSeats":-1,"modTank":-1,"modHydraulics":false,"modExhaust":-1,"modLivery":-1,"modTurbo":false,"modTrunk":-1,"modHorns":-1,"modBrakes":-1,"modSubwoofer":-1}', 'car', NULL, 0, 'GARAGE A', NULL, NULL, '');

-- Dump della struttura di tabella legacycore.ox_inventory
CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(60) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dump dei dati della tabella legacycore.ox_inventory: ~2 rows (circa)
INSERT INTO `ox_inventory` (`owner`, `name`, `data`, `lastupdated`) VALUES
	('', 'FZS1719849013', '[{"name":"money","slot":1,"count":273},{"name":"burger","slot":2,"count":1},{"name":"burger","slot":3,"count":1}]', '2024-07-01 15:55:00'),
	('', '__mechanic__', '[{"count":1,"metadata":{"pricePerMinute":2000,"rentalDuration":1,"VehicleImage":"nui://LGF_Rental/web/img/cars/Kuruma.png","VehicleName":"Kuruma","description":"Vehicle Plate: 82FVB121   \\nRental Duration: 1 minutes   \\nTotal Price: 2000   \\nPlayer Name: Gennaor Calogero  \\nVehicle Name: Kuruma","PlayerName":"Gennaor Calogero","Plate":"82FVB121"},"name":"insurance_rental_keys","slot":2}]', '2024-07-22 19:15:00');


-- Dump della struttura di tabella legacycore.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `charIdentifier` varchar(50) DEFAULT NULL,
  `inventory` text DEFAULT '{}',
  `playerName` varchar(50) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `dob` varchar(50) DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `accounts` text DEFAULT '{}',
  `status` longtext DEFAULT NULL,
  `skin` text DEFAULT '{}',
  `lastSpawn` text DEFAULT '{}',
  `playerGroup` varchar(50) DEFAULT NULL,
  `JobName` varchar(50) DEFAULT NULL,
  `JobLabel` varchar(50) DEFAULT NULL,
  `JobGrade` int(11) DEFAULT NULL,
  `is_dead` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=267 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Dump dei dati della tabella legacycore.users: ~6 rows (circa)
INSERT INTO `users` (`id`, `identifier`, `charIdentifier`, `inventory`, `playerName`, `sex`, `dob`, `height`, `accounts`, `status`, `skin`, `lastSpawn`, `playerGroup`, `JobName`, `JobLabel`, `JobGrade`, `is_dead`) VALUES
	(260, 'license:5c54fbccfc7d92223ebc3e63fec67771759a704a', '1', '{}', 'dawdwa dawdwa', 'Male', '1994-08-31', 170.00, '{"Bank":40000,"money":0}', '{"hunger":0,"thirst":37.00000000000028}', '{"model":"mp_m_freemode_01","components":[{"component_id":0,"drawable":0,"texture":0},{"component_id":1,"drawable":0,"texture":0},{"component_id":2,"drawable":0,"texture":0},{"component_id":3,"drawable":0,"texture":0},{"component_id":4,"drawable":0,"texture":0},{"component_id":5,"drawable":0,"texture":0},{"component_id":6,"drawable":0,"texture":0},{"component_id":7,"drawable":0,"texture":0},{"component_id":8,"drawable":0,"texture":0},{"component_id":9,"drawable":0,"texture":0},{"component_id":10,"drawable":0,"texture":0},{"component_id":11,"drawable":0,"texture":0}],"props":[{"prop_id":0,"texture":-1,"drawable":-1},{"prop_id":1,"texture":-1,"drawable":-1},{"prop_id":2,"texture":-1,"drawable":-1},{"prop_id":6,"texture":-1,"drawable":-1},{"prop_id":7,"texture":-1,"drawable":-1}],"hair":{"highlight":0,"color":0,"style":0},"tattoos":[],"headBlend":{"shapeFirst":0,"shapeMix":0,"shapeSecond":0,"skinMix":0,"skinSecond":0,"skinFirst":0},"headOverlays":{"chestHair":{"opacity":0,"color":0,"style":0},"sunDamage":{"opacity":0,"color":0,"style":0},"moleAndFreckles":{"opacity":0,"color":0,"style":0},"makeUp":{"opacity":0,"color":0,"style":0},"complexion":{"opacity":0,"color":0,"style":0},"lipstick":{"opacity":0,"color":0,"style":0},"ageing":{"opacity":0,"color":0,"style":0},"eyebrows":{"opacity":0,"color":0,"style":0},"blush":{"opacity":0,"color":0,"style":0},"bodyBlemishes":{"opacity":0,"color":0,"style":0},"blemishes":{"opacity":0,"color":0,"style":0},"beard":{"opacity":0,"color":0,"style":0}},"faceFeatures":{"cheeksBoneWidth":0,"eyeBrownHigh":0,"lipsThickness":0,"jawBoneBackSize":0,"chinBoneSize":0,"cheeksBoneHigh":0,"eyeBrownForward":0,"jawBoneWidth":0,"neckThickness":0,"nosePeakHigh":0,"cheeksWidth":0,"chinHole":0,"noseBoneTwist":0,"noseWidth":0,"nosePeakSize":0,"chinBoneLowering":0,"nosePeakLowering":0,"noseBoneHigh":0,"chinBoneLenght":0,"eyesOpening":0},"eyeColor":0}', '{"x":-163.71896362304688,"y":-424.29248046875,"z":33.91508865356445}', 'admin', 'unemployed', 'police', 0, 1),
	(266, 'license:5c54fbccfc7d92223ebc3e63fec67771759a704a', '6', '[{"metadata":{"Expiration":"24-09-2025","description":"Released: 24-09-2024 23:11   \\nOwner: dwadwa awdwadwa","PlayerDob":"1994-05-25","Released":"24-09-2024 23:11","Screen":"https://cdn.discordapp.com/attachments/1217899422604595300/1288246495958663208/screenshot.jpg?ex=66f47c8b&is=66f32b0b&hm=688bcfb010e2ae07202a454b75600a1557a8ac73816715448d74e952e5148bb7&","TypeDocument":"license_id","IdCard":"#X0B0N0","PlayerName":"dwadwa","PlayerSex":"Male","PlayerSurname":"awdwadwa"},"slot":1,"name":"license_id","count":1},{"metadata":{"IdCard":"#F0Y0O0","PlayerName":"dwadwa","PlayerDob":"1994-05-25","Released":"24-09-2024 23:12","Screen":"https://cdn.discordapp.com/attachments/1217899422604595300/1288246636497080421/screenshot.jpg?ex=66f47cac&is=66f32b2c&hm=aeb6d391301fd21095338cc613d692aff2fe03494d215356a868da0e7398f99e&","TypeDocument":"license_car","Expiration":"24-09-2025","description":"Released: 24-09-2024 23:12   \\nOwner: dwadwa awdwadwa","PlayerSex":"Male","PlayerSurname":"awdwadwa"},"slot":2,"name":"license_car","count":1},{"metadata":{"IdCard":"#M0K0F0","description":"Released: 24-09-2024 23:12   \\nOwner: dwadwa awdwadwa","PlayerDob":"1994-05-25","Released":"24-09-2024 23:12","Screen":"https://cdn.discordapp.com/attachments/1217899422604595300/1288246706684694538/screenshot.jpg?ex=66f47cbd&is=66f32b3d&hm=df78c86db37278436c61d5b1bac89a02f031e26a2835d4c95aaff6e7481447ab&","TypeDocument":"license_weapon","PlayerName":"dwadwa","Expiration":"24-09-2025","PlayerSex":"Male","PlayerSurname":"awdwadwa"},"slot":3,"name":"license_weapon","count":1},{"metadata":{"Expiration":"24-09-2025","PlayerName":"dwadwa","PlayerDob":"1994-05-25","Released":"24-09-2024 23:16","Screen":"https://cdn.discordapp.com/attachments/1217899422604595300/1288247714060042270/screenshot.jpg?ex=66f47dad&is=66f32c2d&hm=13b9643d513eb19ee999c48bbe84524e6f3e1cac92e7cbbf45ab92c32878abeb&","TypeDocument":"license_boat","IdCard":"#A0N0E0","description":"Released: 24-09-2024 23:16   \\nOwner: dwadwa awdwadwa","PlayerSex":"Male","PlayerSurname":"awdwadwa"},"slot":4,"name":"license_boat","count":1}]', 'dwadwa awdwadwa', 'Male', '1994-05-25', 185.00, '{"money":0,"Bank":46471162}', '{"thirst":57.10000000000017,"hunger":49.30000000000011}', '{"headOverlays":{"ageing":{"style":0,"opacity":0,"color":0},"eyebrows":{"style":0,"opacity":0,"color":0},"blush":{"style":0,"opacity":0,"color":0},"complexion":{"style":0,"opacity":0,"color":0},"beard":{"style":0,"opacity":0,"color":0},"chestHair":{"style":0,"opacity":0,"color":0},"sunDamage":{"style":0,"opacity":0,"color":0},"moleAndFreckles":{"style":0,"opacity":0,"color":0},"makeUp":{"style":0,"opacity":0,"color":0},"lipstick":{"style":0,"opacity":0,"color":0},"blemishes":{"style":0,"opacity":0,"color":0},"bodyBlemishes":{"style":0,"opacity":0,"color":0}},"tattoos":[],"headBlend":{"shapeFirst":0,"skinSecond":0,"skinFirst":0,"skinMix":0,"shapeMix":0,"shapeSecond":0},"hair":{"style":0,"highlight":0,"color":0},"faceFeatures":{"eyeBrownHigh":0,"cheeksWidth":0,"cheeksBoneWidth":0,"jawBoneBackSize":0,"chinBoneLenght":0,"nosePeakHigh":0,"eyesOpening":0,"noseBoneHigh":0,"chinHole":0,"noseWidth":0,"noseBoneTwist":0,"nosePeakSize":0,"nosePeakLowering":0,"lipsThickness":0,"chinBoneSize":0,"jawBoneWidth":0,"chinBoneLowering":0,"eyeBrownForward":0,"cheeksBoneHigh":0,"neckThickness":0},"props":[{"drawable":-1,"texture":-1,"prop_id":0},{"drawable":-1,"texture":-1,"prop_id":1},{"drawable":-1,"texture":-1,"prop_id":2},{"drawable":-1,"texture":-1,"prop_id":6},{"drawable":-1,"texture":-1,"prop_id":7}],"components":[{"component_id":0,"drawable":0,"texture":0},{"component_id":1,"drawable":0,"texture":0},{"component_id":2,"drawable":0,"texture":0},{"component_id":3,"drawable":0,"texture":0},{"component_id":4,"drawable":0,"texture":0},{"component_id":5,"drawable":0,"texture":0},{"component_id":6,"drawable":0,"texture":0},{"component_id":7,"drawable":0,"texture":0},{"component_id":8,"drawable":0,"texture":0},{"component_id":9,"drawable":0,"texture":0},{"component_id":10,"drawable":0,"texture":0},{"component_id":11,"drawable":0,"texture":0}],"eyeColor":0,"model":"mp_m_freemode_01"}', '{"x":-616.8406372070313,"y":-697.4951171875,"z":36.28705596923828}', 'admin', 'police', 'police', 2, 0);
