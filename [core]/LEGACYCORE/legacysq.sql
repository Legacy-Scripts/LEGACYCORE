
CREATE TABLE IF NOT EXISTS `lgf_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `grade` int(11) DEFAULT NULL,
  `paycheck` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

CREATE TABLE IF NOT EXISTS `lgf_society` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `funds` int(11) NOT NULL,
  `shared` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `lgf_society` (`id`, `name`, `funds`, `shared`) VALUES
	(5, 'police', 47878, 1),
	(7, 'ambulance', 5000, 1),
	(8, 'ems', 5000, 1);

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

CREATE TABLE IF NOT EXISTS `ox_inventory` (
  `owner` varchar(60) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `data` longtext DEFAULT NULL,
  `lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  UNIQUE KEY `owner` (`owner`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `charIdentifier` varchar(50) DEFAULT NULL,
  `inventory` text DEFAULT '{}',
  `playerName` varchar(50) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `dob` tinytext DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `accounts` text DEFAULT '{}',
  `status` longtext DEFAULT '{}',
  `skin` text DEFAULT '{}',
  `lastSpawn` text DEFAULT '{}',
  `playerGroup` varchar(50) DEFAULT NULL,
  `JobName` varchar(50) DEFAULT NULL,
  `JobLabel` varchar(50) DEFAULT NULL,
  `JobGrade` int(11) DEFAULT NULL,
  `is_dead` int(11) DEFAULT NULL,
  `inDuty` tinyint(1) DEFAULT 0,
  `mugshot` longtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

