-- Adminer 4.8.1 MySQL 10.4.27-MariaDB dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `back_order_list`;
CREATE TABLE `back_order_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `receiving_id` int(30) NOT NULL,
  `po_id` int(30) NOT NULL,
  `bo_code` varchar(50) NOT NULL,
  `supplier_id` int(30) NOT NULL,
  `amount` float NOT NULL,
  `discount_perc` float NOT NULL DEFAULT 0,
  `discount` float NOT NULL DEFAULT 0,
  `tax_perc` float NOT NULL DEFAULT 0,
  `tax` float NOT NULL DEFAULT 0,
  `remarks` text DEFAULT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 = pending, 1 = partially received, 2 =received',
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `supplier_id` (`supplier_id`),
  KEY `po_id` (`po_id`),
  KEY `receiving_id` (`receiving_id`),
  CONSTRAINT `back_order_list_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplier_list` (`id`) ON DELETE CASCADE,
  CONSTRAINT `back_order_list_ibfk_2` FOREIGN KEY (`po_id`) REFERENCES `purchase_order_list` (`id`) ON DELETE CASCADE,
  CONSTRAINT `back_order_list_ibfk_3` FOREIGN KEY (`receiving_id`) REFERENCES `receiving_list` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `back_order_list` (`id`, `receiving_id`, `po_id`, `bo_code`, `supplier_id`, `amount`, `discount_perc`, `discount`, `tax_perc`, `tax`, `remarks`, `status`, `date_created`, `date_updated`) VALUES
(1,	1,	1,	'BO-0001',	1,	40740,	3,	1125,	12,	4365,	NULL,	1,	'2021-11-03 11:20:38',	'2021-11-03 11:20:51'),
(2,	2,	1,	'BO-0002',	1,	20370,	3,	562.5,	12,	2182.5,	NULL,	2,	'2021-11-03 11:20:51',	'2021-11-03 11:21:00'),
(3,	4,	2,	'BO-0003',	2,	42826,	5,	2012.5,	12,	4588.5,	NULL,	1,	'2021-11-03 11:51:41',	'2021-11-03 11:52:02'),
(4,	5,	2,	'BO-0004',	2,	10640,	5,	500,	12,	1140,	NULL,	2,	'2021-11-03 11:52:02',	'2021-11-03 11:52:15');

DROP TABLE IF EXISTS `bo_items`;
CREATE TABLE `bo_items` (
  `bo_id` int(30) NOT NULL,
  `item_id` int(30) NOT NULL,
  `quantity` int(30) NOT NULL,
  `price` float NOT NULL DEFAULT 0,
  `unit` varchar(50) NOT NULL,
  `total` float NOT NULL DEFAULT 0,
  KEY `item_id` (`item_id`),
  KEY `bo_id` (`bo_id`),
  CONSTRAINT `bo_items_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `item_list` (`id`) ON DELETE CASCADE,
  CONSTRAINT `bo_items_ibfk_2` FOREIGN KEY (`bo_id`) REFERENCES `back_order_list` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `bo_items` (`bo_id`, `item_id`, `quantity`, `price`, `unit`, `total`) VALUES
(1,	1,	250,	150,	'pcs',	37500),
(2,	1,	125,	150,	'pcs',	18750),
(3,	2,	150,	200,	'Boxes',	30000),
(3,	4,	50,	205,	'pcs',	10250),
(4,	2,	50,	200,	'Boxes',	10000);

DROP TABLE IF EXISTS `item_list`;
CREATE TABLE `item_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `description` text NOT NULL,
  `supplier_id` int(30) NOT NULL,
  `cost` float NOT NULL DEFAULT 0,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `item_list_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplier_list` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `item_list` (`id`, `name`, `description`, `supplier_id`, `cost`, `status`, `date_created`, `date_updated`) VALUES
(1,	'Item 101',	'Sample Only',	1,	150,	1,	'2021-11-02 10:01:55',	'2021-11-02 10:01:55'),
(2,	'Item 102',	'Sample only',	2,	200,	1,	'2021-11-02 10:02:12',	'2021-11-02 10:02:12'),
(3,	'Item 103',	'Sample',	1,	185,	1,	'2021-11-02 10:02:27',	'2021-11-02 10:02:27'),
(4,	'Item 104',	'Sample only',	2,	205,	1,	'2021-11-02 10:02:47',	'2021-11-02 10:02:47');

DROP TABLE IF EXISTS `po_items`;
CREATE TABLE `po_items` (
  `po_id` int(30) NOT NULL,
  `item_id` int(30) NOT NULL,
  `quantity` int(30) NOT NULL,
  `price` float NOT NULL DEFAULT 0,
  `unit` varchar(50) NOT NULL,
  `total` float NOT NULL DEFAULT 0,
  KEY `po_id` (`po_id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `po_items_ibfk_1` FOREIGN KEY (`po_id`) REFERENCES `purchase_order_list` (`id`) ON DELETE CASCADE,
  CONSTRAINT `po_items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `item_list` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `po_items` (`po_id`, `item_id`, `quantity`, `price`, `unit`, `total`) VALUES
(1,	1,	500,	150,	'pcs',	75000),
(2,	2,	300,	200,	'Boxes',	60000),
(2,	4,	200,	205,	'pcs',	41000);

DROP TABLE IF EXISTS `purchase_order_list`;
CREATE TABLE `purchase_order_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `po_code` varchar(50) NOT NULL,
  `supplier_id` int(30) NOT NULL,
  `amount` float NOT NULL,
  `discount_perc` float NOT NULL DEFAULT 0,
  `discount` float NOT NULL DEFAULT 0,
  `tax_perc` float NOT NULL DEFAULT 0,
  `tax` float NOT NULL DEFAULT 0,
  `remarks` text NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0 = pending, 1 = partially received, 2 =received',
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `purchase_order_list_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplier_list` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `purchase_order_list` (`id`, `po_code`, `supplier_id`, `amount`, `discount_perc`, `discount`, `tax_perc`, `tax`, `remarks`, `status`, `date_created`, `date_updated`) VALUES
(1,	'PO-0001',	1,	81480,	3,	2250,	12,	8730,	'Sample',	2,	'2021-11-03 11:20:22',	'2021-11-03 11:21:00'),
(2,	'PO-0002',	2,	107464,	5,	5050,	12,	11514,	'Sample PO Only',	2,	'2021-11-03 11:50:50',	'2021-11-03 11:52:15');

DROP TABLE IF EXISTS `receiving_list`;
CREATE TABLE `receiving_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `form_id` int(30) NOT NULL,
  `from_order` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=PO ,2 = BO',
  `amount` float NOT NULL DEFAULT 0,
  `discount_perc` float NOT NULL DEFAULT 0,
  `discount` float NOT NULL DEFAULT 0,
  `tax_perc` float NOT NULL DEFAULT 0,
  `tax` float NOT NULL DEFAULT 0,
  `stock_ids` text DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `receiving_list` (`id`, `form_id`, `from_order`, `amount`, `discount_perc`, `discount`, `tax_perc`, `tax`, `stock_ids`, `remarks`, `date_created`, `date_updated`) VALUES
(1,	1,	1,	40740,	3,	1125,	12,	4365,	'1',	'Sample',	'2021-11-03 11:20:38',	'2021-11-03 11:20:38'),
(2,	1,	2,	20370,	3,	562.5,	12,	2182.5,	'2',	'',	'2021-11-03 11:20:51',	'2021-11-03 11:20:51'),
(3,	2,	2,	20370,	3,	562.5,	12,	2182.5,	'3',	'Success',	'2021-11-03 11:21:00',	'2021-11-03 11:21:00'),
(4,	2,	1,	64638,	5,	3037.5,	12,	6925.5,	'4,5',	'Sample Receiving (Partial)',	'2021-11-03 11:51:41',	'2021-11-03 11:51:41'),
(5,	3,	2,	32186,	5,	1512.5,	12,	3448.5,	'6,7',	'BO Receive (Partial)',	'2021-11-03 11:52:02',	'2021-11-03 11:52:02'),
(6,	4,	2,	10640,	5,	500,	12,	1140,	'8',	'Sample Success',	'2021-11-03 11:52:15',	'2021-11-03 11:52:15');

DROP TABLE IF EXISTS `return_list`;
CREATE TABLE `return_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `return_code` varchar(50) NOT NULL,
  `supplier_id` int(30) NOT NULL,
  `amount` float NOT NULL DEFAULT 0,
  `remarks` text DEFAULT NULL,
  `stock_ids` text NOT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `supplier_id` (`supplier_id`),
  CONSTRAINT `return_list_ibfk_1` FOREIGN KEY (`supplier_id`) REFERENCES `supplier_list` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `return_list` (`id`, `return_code`, `supplier_id`, `amount`, `remarks`, `stock_ids`, `date_created`, `date_updated`) VALUES
(1,	'R-0001',	2,	3025,	'Sample Issue',	'16,17',	'2021-11-03 13:45:53',	'2021-11-03 13:45:53');

DROP TABLE IF EXISTS `sales_list`;
CREATE TABLE `sales_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `sales_code` varchar(50) NOT NULL,
  `client` text DEFAULT NULL,
  `amount` float NOT NULL DEFAULT 0,
  `remarks` text DEFAULT NULL,
  `stock_ids` text NOT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `sales_list` (`id`, `sales_code`, `client`, `amount`, `remarks`, `stock_ids`, `date_created`, `date_updated`) VALUES
(1,	'SALE-0001',	'John Smith',	7625,	'Sample Remarks',	'24,25,26',	'2021-11-03 14:03:30',	'2021-11-03 14:08:27');

DROP TABLE IF EXISTS `stock_list`;
CREATE TABLE `stock_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `item_id` int(30) NOT NULL,
  `quantity` int(30) NOT NULL,
  `unit` varchar(250) DEFAULT NULL,
  `price` float NOT NULL DEFAULT 0,
  `total` float NOT NULL DEFAULT current_timestamp(),
  `type` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=IN , 2=OUT',
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `item_id` (`item_id`),
  CONSTRAINT `stock_list_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `item_list` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `stock_list` (`id`, `item_id`, `quantity`, `unit`, `price`, `total`, `type`, `date_created`) VALUES
(1,	1,	250,	'pcs',	150,	37500,	1,	'2021-11-03 11:20:38'),
(2,	1,	125,	'pcs',	150,	18750,	1,	'2021-11-03 11:20:51'),
(3,	1,	125,	'pcs',	150,	18750,	1,	'2021-11-03 11:21:00'),
(4,	2,	150,	'Boxes',	200,	30000,	1,	'2021-11-03 11:51:41'),
(5,	4,	150,	'pcs',	205,	30750,	1,	'2021-11-03 11:51:41'),
(6,	2,	100,	'Boxes',	200,	20000,	1,	'2021-11-03 11:52:02'),
(7,	4,	50,	'pcs',	205,	10250,	1,	'2021-11-03 11:52:02'),
(8,	2,	50,	'Boxes',	200,	10000,	1,	'2021-11-03 11:52:15'),
(16,	2,	10,	'pcs',	200,	2000,	2,	'2021-11-03 13:45:53'),
(17,	4,	5,	'boxes',	205,	1025,	2,	'2021-11-03 13:45:53'),
(24,	1,	10,	'pcs',	150,	1500,	2,	'2021-11-03 14:08:27'),
(25,	2,	5,	'pcs',	200,	1000,	2,	'2021-11-03 14:08:27'),
(26,	4,	25,	'boxes',	205,	5125,	2,	'2021-11-03 14:08:27');

DROP TABLE IF EXISTS `supplier_list`;
CREATE TABLE `supplier_list` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `address` text NOT NULL,
  `cperson` text NOT NULL,
  `contact` text NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `supplier_list` (`id`, `name`, `address`, `cperson`, `contact`, `status`, `date_created`, `date_updated`) VALUES
(1,	'Supplier 101',	'Sample Supplier Address 101',	'Supplier Staff 101',	'09123456789',	1,	'2021-11-02 09:36:19',	'2021-11-02 09:36:19'),
(2,	'Supplier 102',	'Sample Address 102',	'Supplier Staff 102',	'0987654332',	1,	'2021-11-02 09:36:54',	'2021-11-02 09:36:54'),
(6,	'Supplier 103',	'dvdsvsdv',	'Supplier Staff 103',	'33333333',	1,	'2022-12-31 16:03:32',	'2022-12-31 16:03:46'),
(7,	'Supplier 104',	'Supplier Staff 104',	'Viraj',	'4624732724724',	1,	'2022-12-31 17:15:49',	'2022-12-31 17:15:49');

DROP TABLE IF EXISTS `system_info`;
CREATE TABLE `system_info` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `meta_field` text NOT NULL,
  `meta_value` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `system_info` (`id`, `meta_field`, `meta_value`) VALUES
(1,	'name',	'Stock Management System - PHP'),
(6,	'short_name',	'SMS- PHP'),
(11,	'logo',	'uploads/logo-1635816671.png'),
(13,	'user_avatar',	'uploads/user_avatar.jpg'),
(14,	'cover',	'uploads/cover-1635816671.png'),
(15,	'content',	'Array');

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(50) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(250) NOT NULL,
  `middlename` text DEFAULT NULL,
  `lastname` varchar(250) NOT NULL,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `avatar` text DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `type` tinyint(1) NOT NULL DEFAULT 0,
  `date_added` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `users` (`id`, `firstname`, `middlename`, `lastname`, `username`, `password`, `avatar`, `last_login`, `type`, `date_added`, `date_updated`) VALUES
(1,	'Adminstrator',	NULL,	'Admin',	'admin',	'e10adc3949ba59abbe56e057f20f883e',	'uploads/avatar-1.png?v=1635556826',	NULL,	1,	'2021-01-20 14:02:37',	'2022-12-31 17:04:26'),
(10,	'John',	NULL,	'Smith',	'jsmith',	'e10adc3949ba59abbe56e057f20f883e',	'uploads/avatar-10.png?v=1635920488',	NULL,	3,	'2021-11-03 14:21:28',	'2022-12-31 17:06:57'),
(11,	'Claire',	NULL,	'Blake',	'cblake',	'e10adc3949ba59abbe56e057f20f883e',	'uploads/avatar-11.png?v=1635920566',	NULL,	2,	'2021-11-03 14:22:46',	'2022-12-31 17:07:05');

DROP TABLE IF EXISTS `user_meta`;
CREATE TABLE `user_meta` (
  `user_id` int(30) NOT NULL,
  `meta_field` text NOT NULL,
  `meta_value` text NOT NULL,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `work_monitor`;
CREATE TABLE `work_monitor` (
  `id` int(30) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `address` text NOT NULL,
  `aperson` text NOT NULL,
  `contact` text NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `date_created` datetime NOT NULL DEFAULT current_timestamp(),
  `date_updated` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

INSERT INTO `work_monitor` (`id`, `name`, `address`, `aperson`, `contact`, `status`, `date_created`, `date_updated`) VALUES
(1,	'Supplier 101',	'BB111',	'Kamal',	'444444',	0,	'2022-12-31 15:17:07',	'2022-12-31 16:04:16'),
(2,	'Supplier 102',	'FF222',	'Joni',	'6666',	1,	'2022-12-31 15:23:02',	'2022-12-31 17:14:34'),
(4,	'Supplier 103',	'GGGGGGGGGGG',	'Sunil',	'33333333',	1,	'2022-12-31 17:14:49',	'2022-12-31 17:14:49');

-- 2022-12-31 11:48:02
