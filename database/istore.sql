-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: istore
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (1,1,23,4);
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `order_id` int unsigned NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `price` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `order_id` (`order_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (1,1,23,1,580000),(2,2,46,1,250000),(3,3,89,1,4000);
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `total` int NOT NULL DEFAULT '0',
  `status` enum('pending','confirmed','shipped','delivered','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `city` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cnic` char(13) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_method` enum('jazzcash','easypaisa','bank_transfer') COLLATE utf8mb4_unicode_ci NOT NULL,
  `transaction_id` varchar(60) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1,1,580000,'confirmed','2026-10-16 20:39:03','Ali','03334280066','Cant , Lahore','Lahore','3660236647385','jazzcash','678092'),(2,3,250000,'cancelled','2026-10-17 05:09:15','Abdullah Sani','03024567891','Bhata chowk lahore','Lahore','3530135747733','bank_transfer','0987652'),(3,2,4000,'cancelled','2026-10-17 05:18:47','Ijaz','03217654280','Wapda Town Multan','Multan','3530168947654','jazzcash','754128');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category` enum('iphone','macbook','tablets','earbuds','chargers') COLLATE utf8mb4_unicode_ci NOT NULL,
  `series` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `variant` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `image` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` int DEFAULT '0',
  `stock` int DEFAULT '0',
  `status` enum('available','coming_soon') COLLATE utf8mb4_unicode_ci DEFAULT 'available',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'iphone','iPhone 13','iPhone 13 mini','128GB / 256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSXKOI54lwNLU_TJmd7Zj_1wvGKLUPJIj0WjXc2430kFw&s',150000,10,'available'),(2,'iphone','iPhone 13','iPhone 13','128GB / 256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQl3zC-rwKLKhbBh_iW1BqEXHnXN5WSnpu5XbxTV7UzSg&s=10',170000,10,'available'),(3,'iphone','iPhone 13','iPhone 13 Pro','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToUvKWZxyZk6AYv7vmrMgOLvhkKlOpb6_cphsznvmrhQ&s=10',230000,8,'available'),(4,'iphone','iPhone 13','iPhone 13 Pro Max','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpqy0C_j9oKGI5MQPK_I5HfEJZ5C2NTjRRVnkmDhfA7Q&s=10',260000,8,'available'),(5,'iphone','iPhone 14','iPhone 14','128GB / 256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQx4TY4jZODjN4d1CCQfyjk5y4T6FDKMI5M4AzPuFx9bA&s=10',200000,10,'available'),(6,'iphone','iPhone 14','iPhone 14 Plus','128GB / 256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ68ZIi20HakSfMUDcx9e9Yh5aGMHYby1WICisbr0SG2g&s=10',230000,10,'available'),(7,'iphone','iPhone 14','iPhone 14 Pro','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0Lwhq-JBqtFhbmFUiT7rUpW_F3IJilAVpKjkZn4KAWw&s=10',300000,8,'available'),(8,'iphone','iPhone 14','iPhone 14 Pro Max','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTINCxxSaOaiUYKvoxKLMBXX23ld6cJmdYOurDXDzJ6Rw&s=10',340000,8,'available'),(9,'iphone','iPhone 15','iPhone 15','128GB / 256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjE9GEOXLeA5SeH8XlrNhqir_OoAcBtvEUWoX14IpNCA&s=10',260000,12,'available'),(10,'iphone','iPhone 15','iPhone 15 Plus','128GB / 256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTH9WB99YsRe0zM16Q6JneK9QRc3gRl4AqVv6RrsT_tZw&s=10',290000,12,'available'),(11,'iphone','iPhone 15','iPhone 15 Pro','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqXXzFpD11dELk0ibEDRTLKTiRdjoh95lfkkGUUbcdow&s=10',360000,10,'available'),(12,'iphone','iPhone 15','iPhone 15 Pro Max','256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQEQSbH4o-6xeUSfZM6BIHShKqoRSa8pbfqw_W0Ik6rfQ&s=10',420000,10,'available'),(13,'iphone','iPhone 16','iPhone 16e','128GB / 256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCgG9AI0oY5OHvnbfgBjz14H5DtKJakchbKMnsfJqByg&s=10',220000,12,'available'),(14,'iphone','iPhone 16','iPhone 16','128GB / 256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQMz_yQJDoJ5LzIjWMreKFHeXZrXI2e98CaN7n3cUAerw&s',310000,12,'available'),(15,'iphone','iPhone 16','iPhone 16 Plus','128GB / 256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0HmlWOZbWUhqlE_L8-FyejbZw3azsmsyqWmG5LN_zkw&s',340000,12,'available'),(16,'iphone','iPhone 16','iPhone 16 Pro','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSrEq38tcK72I0Fmoi_1hCW6KThjM3-ZtzWx-fp3d32w&s',410000,10,'available'),(17,'iphone','iPhone 16','iPhone 16 Pro Max','256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkesQ81YakOTQIaFqY8xfa4AST5b2Z_eH8C8ke70aN1w&s=10',470000,10,'available'),(18,'iphone','iPhone 17','iPhone 17e','256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlcMFlvtO54zInstPJONmZToEc5K7FRXIgRiSDTbtRQg&s=10',260000,12,'available'),(19,'iphone','iPhone 17','iPhone 17','256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgJvSL827emiJvcQyzXGfvGX2EG7Hkfd5aN3nDjgFItw&s=10',380000,12,'available'),(20,'iphone','iPhone 17','iPhone Air','256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTj5XYzKpbR7ySQo1dP5Dt8iXW8PwD018D0DrEGl2U_rA&s=10',450000,8,'available'),(21,'iphone','iPhone 17','iPhone 17 Pro','256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTpG0GLhd4AbRKZiodjTELO_tfprgx7CWaNMsiOlENW6w&s',500000,10,'available'),(22,'iphone','iPhone 17','iPhone 17 Pro Max','256GB / 512GB / 1TB / 2TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlLcrOR50eZGfjJAeWejseTXv-1Vq_S29FzF3Ia8Djeg&s',560000,10,'available'),(23,'iphone','iPhone 18','iPhone 18 Pro','256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT3flocSSnqcK_VwX3WfFZK7rQ-MMYY5T91dPvxySw0AQ&s=10',580000,6,'available'),(24,'iphone','iPhone 18','iPhone 18 Pro Max','256GB / 512GB / 1TB / 2TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST0Rjfl4eWMVYn2lxXEbOChRCZtxNC2-VxNwVoh1t1xw&s=10',640000,5,'available'),(25,'macbook','Apple M1','MacBook Air 13-inch','M1',NULL,'https://www.apple.com/v/macbook-air/z/images/overview/design/color/design_magsafe_skyblue__gii6y9jn1yai_large_2x.jpg',190000,6,'available'),(26,'macbook','Apple M1','MacBook Pro 14-inch','M1 Pro / M1 Max',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/mac-macbook-pro-size-select-202601-14inch_AV1?wid=5120&hei=3280&fmt=webp&qlt=90&.v=aXlkdGF0T0RUUVdDckNLaUc0OEE0NGNlZWUwMTIzdTlRMENjTTRINjJoQURoTm5FNTJGRmExT2hTTHNPVTBaeWtXOFZBWlBHUmZ1SFluOWlKMkovNGhWb1BiTjRORlc1Y1lKU3JWempySktWM0Jid1FkbUMwMWNjbDVqTXhzQzVmbW94YnYxc1YvNXZ4emJGL0IxNFp3&traceId=1',420000,6,'available'),(27,'macbook','Apple M1','MacBook Pro 16-inch','M1 Pro / M1 Max',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/mac-macbook-pro-size-select-202601-16inch_AV1?wid=5120&hei=3280&fmt=webp&qlt=90&.v=aXlkdGF0T0RUUVdDckNLaUc0OEE0NGNlZWUwMTIzdTlRMENjTTRINjJoQWdyQzZaKzJpUzZwSXJlNEhnR2Z2L2tXOFZBWlBHUmZ1SFluOWlKMkovNGhWb1BiTjRORlc1Y1lKU3JWempySkpYSWxDeGZpS1R3WFdGK2o3eFZOZmJmbW94YnYxc1YvNXZ4emJGL0IxNFp3&traceId=1',500000,6,'available'),(28,'macbook','Apple M2','MacBook Air 13-inch','M2',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/MDFW4?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=clBRMGZyUzVQT09hREZSR0w3MlQvd2tuVHYzMERCZURia3c5SzJFOTlPZ1pzK2NwN0lUNk9teEkzbHhVNjBDZStxNnpyQk1PMjBaU0dTUGRRZGR0WWc',260000,6,'available'),(29,'macbook','Apple M2','MacBook Air 15-inch','M2',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/HSF12?wid=890&hei=890&fmt=jpeg&qlt=90&.v=YklNOWRLOW9RNWxMWjJrNmZ3b2lDNHExblZJSGFXSFVPMUE2c2RxMy8rSXl1bUtxME5idFdvUXM2d2NpeXFsS2taWUhzYWh4b2pIbTh5MmQxUDhZaEE',320000,6,'available'),(30,'macbook','Apple M2','MacBook Pro 13-inch','M2',NULL,'https://www.apple.com/v/macbook-pro-13/p/images/overview/retina_hero_hardware__bw8sfea616j6_large_2x.jpg',300000,5,'available'),(31,'macbook','Apple M2','MacBook Pro 14-inch','M2 Pro / M2 Max',NULL,'https://appleworlds.pk/wp-content/uploads/2023/09/mbp14-spacegray-select-202301.jpg.webp',480000,4,'available'),(32,'macbook','Apple M2','MacBook Pro 16-inch','M2 Pro / M2 Max',NULL,'https://static.webx.pk/files/4012/Images/1-4012-1679109-200123072943672.jpg',580000,4,'available'),(33,'macbook','Apple M3','MacBook Air 13-inch','M3',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/MGYY4?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=TW9xSkVEWFhIa3FqcStHcjNvdEhwZ2tuVHYzMERCZURia3c5SzJFOTlPaTVOVWVPa1N4MnU3LzNiREZjSkZaNHA1RDJ5MHAyNmMyNnlIWUdIaGVLUnc',330000,6,'available'),(34,'macbook','Apple M3','MacBook Air 15-inch','M3',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/MGYY4_AV4?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=QTNnS09qWUFNcnptSEZqR29EOURGMVZya2lKWlJmUEwrYndWOTJiVWJWQUYwVmtIbGRkS25RMVpBRlo0bk5DUXdQU0hFTndjakwwZ2ExMS9JVTlWSWc',400000,6,'available'),(35,'macbook','Apple M3','MacBook Pro 14-inch','M3 / M3 Pro / M3 Max',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/refurb-mbp14-m4-spaceblack-202502_AV4?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=WjJGMFJHUEgwNFoydzVmZ0IxN1AvQk8zVnlEd1o1SE05NWdMUEFHWVMzZ254NFBXSWRmS0NnM1JRSVIwb0RtVkNTZE8vZlFNRjROdVREMHJZVDMwNklQR3Boa0tlL3dsakNQSnpPMHV6ZjI5QmY2OUdzTWhFUU5seXBaaUZTeUQ',480000,5,'available'),(36,'macbook','Apple M3','MacBook Pro 16-inch','M3 Pro / M3 Max',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/refurb-mbp14-m4-spaceblack-202502?wid=1144&hei=1144&fmt=jpeg&qlt=90&.v=WjJGMFJHUEgwNFoydzVmZ0IxN1AvQk8zVnlEd1o1SE05NWdMUEFHWVMzaDdYVFFlVW9jZjl4K3FocHU2bHlSenV2eTQ1SkZlZU9lQ1FZSE9SaVJ1T01JeFpocHY0dTd4eGpqcnJQL1JoZnRDUnpaVWFQcjl3SFpDZjAzNzRreVc',650000,4,'available'),(37,'macbook','Apple M4','MacBook Air 13-inch','M4',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/MDFW4?wid=890&hei=890&fmt=jpeg&qlt=90&.v=TVZjYlNHaFJNWXNKS3hnTjBZU2thSXExblZJSGFXSFVPMUE2c2RxMy8rS1k0bHBLaWFydnd1M2dkWnNlNnh0L3pVZTd2Rkw0MGdDbXFOVnkyczllMEE',360000,8,'available'),(38,'macbook','Apple M4','MacBook Air 15-inch','M4',NULL,'https://www.apple.com/v/macbook-air/z/images/overview/design/color/design_top_midnight__fvf2p6124tqq_large_2x.jpg',430000,8,'available'),(39,'macbook','Apple M4','MacBook Pro 14-inch','M4 / M4 Pro / M4 Max',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/refurb-mbp14-m4-spaceblack-202502?wid=890&hei=890&fmt=jpeg&qlt=90&.v=WjJGMFJHUEgwNFoydzVmZ0IxN1AvQk8zVnlEd1o1SE05NWdMUEFHWVMzaFNqdGFHYTJPMjVSTmxtYk9Kek85Qy85S3R4M0M3WGhIQVNOK3lBdUI5K1plWGYyOXhKTW1yaXp6SlJ5SDgybFhXNm9oamhpbmdGcHIwa2hOU3lmQkw',520000,5,'available'),(40,'macbook','Apple M4','MacBook Pro 16-inch','M4 Pro / M4 Max',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/refurb-mbp16-m4-spaceblack-202502?wid=890&hei=890&fmt=jpeg&qlt=90&.v=d04ycXJNT3FjYU8yTmdpcGxNTTc2eE8zVnlEd1o1SE05NWdMUEFHWVMzaFNqdGFHYTJPMjVSTmxtYk9Kek85Qy85S3R4M0M3WGhIQVNOK3lBdUI5K2NmT3lDcEt1YU9kd3dlU3pPejJGQUFUUFRyb2RjNHk0akgzMk1vc0ErMzk',700000,4,'available'),(41,'macbook','Apple M5','MacBook Air 13-inch','M5',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/MWR43?wid=890&hei=890&fmt=jpeg&qlt=90&.v=OTd0Ymtsb1hJUURXTnFUQ1NuU2dxNHExblZJSGFXSFVPMUE2c2RxMy8rS1k0bHBLaWFydnd1M2dkWnNlNnh0L3JDL1ZOVXhmYUhaZ0JJK1FIWjNPNXc',420000,8,'available'),(42,'macbook','Apple M5','MacBook Air 15-inch','M5',NULL,'https://www.apple.com/v/macbook-air/z/images/overview/design/color/design_top_starlight__dtojfd6ibywm_large_2x.jpg',490000,8,'available'),(43,'macbook','Apple M5','MacBook Pro 14-inch','M5 / M5 Pro / M5 Max',NULL,'https://www.apple.com/v/macbook-pro/specs/d/images/specs/14-inch/macbook_pro_14_inch__fjlrd633eki2_large_2x.jpg',560000,5,'available'),(44,'macbook','Apple M5','MacBook Pro 16-inch','M5 Pro / M5 Max',NULL,'https://www.apple.com/v/macbook-pro/specs/d/images/specs/16-inch/macbook_pro_16_inch__cqvg4x5ohjv6_large_2x.jpg',760000,4,'available'),(45,'macbook','MacBook Neo','MacBook Neo 13-inch','A18 Pro',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/refurb-mac-neo-a18-pro-citrus-202606?wid=890&hei=890&fmt=jpeg&qlt=90&.v=VFV6RG10eUMvaGwrUDMrSzU2QS8xYWpuTGF1UmZlWm1DcjRzeXRHRjdCWHhBcHRaTGlZcnBCcTNuRlJ1OWVKbkhUWkczOW1kVFFMYll1UjVKRlN6N2V2MHhUK1hWTUpnN0poZDNVWCtHMXBBTXV1QjdZaWlad1FOUExYQ0F4MXo',180000,10,'available'),(46,'tablets','iPad Pro','iPad Pro 11-inch (M1)','128GB / 256GB / 512GB / 1TB / 2TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSni5KweLQxAFCd1ciIzOxX3a0JI8eQ_Yq6opdojdbPDQ&s',250000,5,'available'),(47,'tablets','iPad Pro','iPad Pro 12.9-inch (M1)','128GB / 256GB / 512GB / 1TB / 2TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSKZ2rXqKExc0L05Tgwq75N27x8BOxSZfO7viNdkGFIKA&s=10',330000,5,'available'),(48,'tablets','iPad Pro','iPad Pro 11-inch (M2)','128GB / 256GB / 512GB / 1TB / 2TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHrxV9M3sjEdl4yfBn4EPgJpm8D0Mv0Q_O76Gw3FTGWw&s=10',290000,5,'available'),(49,'tablets','iPad Pro','iPad Pro 12.9-inch (M2)','128GB / 256GB / 512GB / 1TB / 2TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTLu5MeGYwTJdl2756kc_5vsoonV5PpEKUC9eT9QCd2zQ&s=10',370000,5,'available'),(50,'tablets','iPad Pro','iPad Pro 11-inch (M4)','256GB / 512GB / 1TB / 2TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQCu4jABrCyTW9OoTBtLM4P3QoAGb9Hywg5AvfAz5xjiw&s=10',400000,5,'available'),(51,'tablets','iPad Pro','iPad Pro 13-inch (M4)','256GB / 512GB / 1TB / 2TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlgFUcFUuln-n92AVwGwYnvsEhDSL1GpM9Sf9YgSX4eA&s=10',480000,5,'available'),(52,'tablets','iPad Pro','iPad Pro 11-inch (M5)','256GB / 512GB / 1TB / 2TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3LzAebIdmS9eeAHqIPFZVAjUj5nCAA00VkkxmR0Zc1A&s=10',430000,6,'available'),(53,'tablets','iPad Pro','iPad Pro 13-inch (M5)','256GB / 512GB / 1TB / 2TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT-ow2arEwx5Q2-yoAxauRD1P6T3hDpjJFLVJ0JlL9v0g&s=10',520000,6,'available'),(54,'tablets','iPad Air','iPad Air 10.9-inch (M1)','64GB / 256GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIy2Dhn_1B1utgyxR5aviy51oS5S5QyMK3ujPqIiLrVg&s=10',200000,5,'available'),(55,'tablets','iPad Air','iPad Air 11-inch (M2)','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQp21YkeCean1iPrWIgYijQacpIKfxDJNcRGP-1tlFeqg&s=10',230000,5,'available'),(56,'tablets','iPad Air','iPad Air 13-inch (M2)','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQlgFUcFUuln-n92AVwGwYnvsEhDSL1GpM9Sf9YgSX4eA&s=10',290000,6,'available'),(57,'tablets','iPad Air','iPad Air 11-inch (M3)','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS97kTrv-onVnbj6x-KFhTlsnItK-cKlZibKGLo8AYDMg&s=10',260000,6,'available'),(58,'tablets','iPad Air','iPad Air 13-inch (M3)','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRWXQoWdeWFB4LzYkuB4ecgiLlKFCZQL-7R3_l6z13RQ&s=10',320000,6,'available'),(59,'tablets','iPad Air','iPad Air 11-inch (M4)','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIQl_khkQcCaPgtN8E-Xo886BXg_WqL3_XbsLZCAgWGw&s=10',280000,8,'available'),(60,'tablets','iPad Air','iPad Air 13-inch (M4)','128GB / 256GB / 512GB / 1TB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTnNdyRLYfdo5TSohAWp5qoY5mv5m2Quy2Rh4V-g3EZ4A&s=10',350000,8,'available'),(61,'tablets','iPad','iPad (9th generation)','64GB / 256GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR0qEY1ZKU1LgDp5qQr-50SLqvJuIcw4hyVoB0z_q5pJA&s=10',90000,8,'available'),(62,'tablets','iPad','iPad (10th generation)','64GB / 256GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQyXIiwtFh7ElAWjHq-ZFurpH0JidT7ya4_hNBjjWWeNg&s=10',130000,8,'available'),(63,'tablets','iPad','iPad (11th generation)','128GB / 256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQINp5kqaX2S1FLXry3ehNClMF076R-Dcw7j8TNWajIeg&s=10',140000,10,'available'),(64,'tablets','iPad mini','iPad mini (6th generation)','64GB / 256GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzwGlos9eS-P0VQut30tNCRsdCmCPr5MfYlTTQK838mg&s=10',160000,6,'available'),(65,'tablets','iPad mini','iPad mini (A17 Pro)','128GB / 256GB / 512GB',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQs5FxLPfRDpN-kgD-b7nD0J78j_Gd019sp8CZLtbccxw&s=10',190000,8,'available'),(66,'earbuds','AirPods','AirPods (3rd generation)','MagSafe Charging Case',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRTOv3EuakCepo2RQwP66Xi3eYP-byk_OhCHuTh1_ULSg&s=10',45000,20,'available'),(67,'earbuds','AirPods','AirPods 4','USB-C',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVNGkIwibb8eUwjKxIPRzLNRCYYfn3CV9ZtuO8JEeJ5g&s=10',40000,25,'available'),(68,'earbuds','AirPods','AirPods 4 with ANC','Active Noise Cancellation',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCgW7NKnmj-Qz4OKsDLl2Dez5nDrjus293n7Qep0pZEw&s=10',55000,25,'available'),(69,'earbuds','AirPods Pro','AirPods Pro (2nd generation)','Lightning',NULL,'https://bnwcollections.com/uploads/products/1701759784AirPods%20Pro-bnw.webp',65000,15,'available'),(70,'earbuds','AirPods Pro','AirPods Pro (2nd generation)','USB-C',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROIHJJSQAFmNCnXBHSwWB5wdwmsK9-oFZBGnMz5CKOaw&s=10',70000,15,'available'),(71,'earbuds','AirPods Pro','AirPods Pro 3','USB-C',NULL,'https://store.storeimages.cdn-apple.com/1/as-images.apple.com/is/airpods-pro-3-hero-select-202509?wid=890&hei=890&fmt=jpeg&qlt=90&.v=cmp4MmZ6OWxOeHNNTXh4SzlBNUpEb1RucE9zZTI5eEREaWZpY29lSld3eUptek50N2NUQ2VXdHJ5VEVlUUpYcmJGcXNRQnFCV0w3WVRjTExvdm1ic1YxRUxFRmRlWDBITzhnRmZ5OTRmaVdKTExiOEFsRmxtQ2Nua0tRSC83MkI',80000,20,'available'),(72,'earbuds','AirPods Max','AirPods Max','Lightning',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqL7QSjSll-6pwjykPupXXsKT7jntz9Udlxn59i0DbXQ&s=10',140000,6,'available'),(73,'earbuds','AirPods Max','AirPods Max','USB-C',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBW1tOWzs-6aTbxkOpOdZSEQyhpdJjFMkljTkSRvxiJA&s=10',150000,6,'available'),(74,'earbuds','AirPods Max','AirPods Max 2','USB-C',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBLPn01whWZxED5eSSeehvEcPTRELNKLY9w6Kp1g8mRA&s=10',170000,8,'available'),(75,'chargers','Power Adapters','20W USB-C Power Adapter','iPhone / iPad',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThpX5XqCjSSw8lnFGACKSjs_DgazIbr5ayCrShPt8XSQ&s=10',6000,50,'available'),(76,'chargers','Power Adapters','30W USB-C Power Adapter','iPhone / iPad / MacBook Air',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQpIOAJgw6_uOGGsvRQoGyZxHDfC8L7Rq_D9iGFrrSGTw&s=10',9000,40,'available'),(77,'chargers','Power Adapters','35W Dual USB-C Port Compact Power Adapter','Dual port',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQSp6D_Gpnu8i7bqW6PLLrNwtOnh4-fGMizdocCBJJXQ&s=10',12000,40,'available'),(78,'chargers','Power Adapters','40W Dynamic Power Adapter','iPhone fast charging',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHNUWOkR4ZYakKZ0YUUtvwCioZ8Wprz4p6ZpvxKzVi5A&s=10',11000,40,'available'),(79,'chargers','Power Adapters','67W USB-C Power Adapter','MacBook Pro 14-inch',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSc_91I6W2PUkm1_bsQUk460wKhB_FVGBPQd5-eEhR6ow&s=10',18000,30,'available'),(80,'chargers','Power Adapters','70W USB-C Power Adapter','MacBook Air 15-inch',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQH-kQIoICDKQUy_hbM8EC3Gk0ddewYOeZkrnZiMF3mLw&s=10',20000,30,'available'),(81,'chargers','Power Adapters','96W USB-C Power Adapter','MacBook Pro 14-inch / 16-inch',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0iN-kjpC3asDyiSetab8hQJh8ABBSxx-8Vsh-E6VLRg&s=10',25000,25,'available'),(82,'chargers','Power Adapters','140W USB-C Power Adapter','MacBook Pro 16-inch',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRDw-wf-HLeiCIgc5DO_5ZWGgq0xg6O1r57HqU6rYZmIg&s=10',32000,25,'available'),(83,'chargers','MagSafe','MagSafe Charger','1 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0fz_k96a81YM-Z4AVIpUK2_Tor7ezZsvuo_J3eQoTYw&s=10',12000,30,'available'),(84,'chargers','MagSafe','MagSafe Charger','2 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSoUbugX9JoGqcGUaQGBGPyuP3KM7aF_igt72MehXoBwA&s=10',15000,30,'available'),(85,'chargers','MagSafe','Qi2.2 25W MagSafe Charger','1 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpmD7j_Pu9W0AQY6Z5pkhvcUyegca_pSq7UT-Q4i_3jw&s=10',15000,30,'available'),(86,'chargers','MagSafe','MagSafe Battery Pack','iPhone',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTf7mmaANJ-pwasBwBflqgCSvDKkzblUgQ84t2t3RTPAg&s=10',28000,15,'available'),(87,'chargers','Cables','USB-C Charge Cable','1 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSl62NKVfSe2ZVHBqiajNwKN6yVpZ9yCIrBPnKGeElgxQ&s=10',4000,60,'available'),(88,'chargers','Cables','USB-C Charge Cable','2 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZ4aMZiVKT0wAkOlgis712ZFlEjyYR04YXf3KHblWd_A&s=10',5500,60,'available'),(89,'chargers','Cables','USB-C to Lightning Cable','1 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9CFt7mu-xq6vuAnhyKz_Rbfa2PMuQ8iiXLlZQ14MHEQ&s=10',4000,60,'available'),(90,'chargers','Cables','USB-C to Lightning Cable','2 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROHlCLqjwxA4GqQh3Wn-l7TmG2Aj-yn10Hw6t-j8lPmg&s=10',5500,60,'available'),(91,'chargers','Cables','USB-C Woven Charge Cable','1 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQwuf1qpPAv7v8E1ljVPqI9L0NGFRkFu9h6AxVMCNYpyA&s=10',7000,40,'available'),(92,'chargers','Cables','USB-C Woven Charge Cable','2 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtS_ggixB6hPn2C5-Pp7tAQGiAJc5nYS-4J864tEi_LQ&s=10',9000,40,'available'),(93,'chargers','Cables','Thunderbolt 4 (USB-C) Pro Cable','1.8 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxL5Ph6Y9QEQefUKcYv4mdIfqD1I7TaN2tMsbUakh4gQ&s=10',16000,20,'available'),(94,'chargers','Cables','USB-C to MagSafe 3 Cable','2 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPa2TaLJIGdl83m6cO4nUcLKN0QkBCd9AgBT6720dlfw&s=10',12000,25,'available'),(95,'chargers','Cables','Apple Watch Magnetic Fast Charger to USB-C Cable','1 m',NULL,'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQfWU4O0hv3hSnIIP5c7ILTkYORp4zwsyNYkIF2RAMew&s=10',9000,30,'available');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `product_id` int NOT NULL,
  `rating` tinyint NOT NULL,
  `comment` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `role` enum('user','admin') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Uzair Khan','ali875@gmail.com','$2y$10$7sXBfr1hIzJAoeegTbX.huTXopJwbQ7w2bPK2i3s.aN1.CFLapjNi','2026-10-15 08:09:29','admin'),(2,'ahmad khan','ahmad875@gmail.com','$2y$10$5ljuR0t8iq3TnvpLoNIubuuPRLi/8JcXPF3XKpQ8yoq5XGcxUuzeq','2026-10-16 04:51:03','user'),(3,'sani','sani875@gmail.com','$2y$10$LcY1MiaeOLhh8NPT8Vwuq.zVOGK1sfE7enF/9VkjTNb5JmYRsybQm','2026-10-16 17:42:37','user');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlist`
--

DROP TABLE IF EXISTS `wishlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlist` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int unsigned NOT NULL,
  `product_id` int NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `priority` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Medium',
  `notes` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`product_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `wishlist_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `wishlist_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlist`
--

LOCK TABLES `wishlist` WRITE;
/*!40000 ALTER TABLE `wishlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `wishlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-06 14:37:43
