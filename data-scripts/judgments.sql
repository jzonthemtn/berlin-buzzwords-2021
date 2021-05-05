CREATE DATABASE IF NOT EXISTS `judgments`;

USE `judgments`;

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
