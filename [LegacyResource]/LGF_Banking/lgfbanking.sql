

CREATE TABLE IF NOT EXISTS `lgf_banking` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `Owner` varchar(100) NOT NULL,
  `Transaction` longtext NOT NULL,
  `Pin` char(4) NOT NULL,
  `CardNumber` varchar(19) NOT NULL,
  `CVC` char(3) NOT NULL,
  `Expiry` varchar(5) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

