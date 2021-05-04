-- MySQL dump 10.13  Distrib 8.0.23, for Linux (x86_64)
--
-- Host: 35.229.88.95    Database: judgments
-- ------------------------------------------------------
-- Server version	5.7.33-google-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '18416f42-ac1b-11eb-baae-42010a8e005b:1-17092';

--
-- Table structure for table `judgments`
--

DROP TABLE IF EXISTS `judgments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `judgments` (
  `document_id` int(11) NOT NULL,
  `relevance` int(11) DEFAULT NULL,
  PRIMARY KEY (`document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=armscii8 COLLATE=armscii8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `judgments`
--

LOCK TABLES `judgments` WRITE;
/*!40000 ALTER TABLE `judgments` DISABLE KEYS */;
INSERT INTO `judgments` VALUES (771,3),(772,2),(1585,3),(8871,3),(9279,3),(9479,3),(10437,3),(10719,3),(11395,3),(13358,3),(13378,3),(13673,3),(13767,3),(17037,2),(17979,3),(18147,2),(26386,3),(26985,3),(32307,3),(49852,3),(50652,3),(51052,3),(52055,3),(73191,3),(73961,2),(74352,3),(77934,1),(124601,2),(141102,2),(207871,0),(237710,3),(245508,3),(289728,3),(295884,3),(311765,3),(333348,3),(339543,3),(355547,3),(360920,3),(370071,3);
/*!40000 ALTER TABLE `judgments` ENABLE KEYS */;
UNLOCK TABLES;
