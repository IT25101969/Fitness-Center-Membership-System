-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: fcms_db
-- ------------------------------------------------------
-- Server version	8.0.42

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

--
-- Current Database: `fcms_db`
--

/*!40000 DROP DATABASE IF EXISTS `fcms_db`*/;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `fcms_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `fcms_db`;

--
-- Table structure for table `attendance`
--

DROP TABLE IF EXISTS `attendance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance` (
  `attendance_id` varchar(10) NOT NULL,
  `check_in_time` varchar(20) DEFAULT NULL,
  `date` varchar(20) DEFAULT NULL,
  `member_id` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`attendance_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance`
--

LOCK TABLES `attendance` WRITE;
/*!40000 ALTER TABLE `attendance` DISABLE KEYS */;
INSERT INTO `attendance` VALUES ('A001','07:35:22','2025-06-10','M001'),('A002','08:12:05','2025-06-10','M002'),('A003','09:00:41','2025-06-10','M003'),('A004','07:28:15','2025-06-11','M001'),('A005','10:05:33','2025-06-11','M004'),('A006','08:00:00','2025-06-12','M002'),('A007','07:55:12','2025-06-12','M005'),('A008','07:30:10','2025-06-13','M001'),('A009','09:15:44','2025-06-13','M003'),('A010','08:20:30','2025-06-14','M005'),('A011','02:49:29','2026-04-22','M001'),('A012','23:45:57','2026-04-22','M001'),('A013','23:22:41','2026-04-25','M001'),('A014','23:23:07','2026-04-25','M002'),('A015','23:23:17','2026-04-25','M003');
/*!40000 ALTER TABLE `attendance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `enrollments`
--

DROP TABLE IF EXISTS `enrollments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `enrollments` (
  `enrollment_id` varchar(10) NOT NULL,
  `class_id` varchar(10) DEFAULT NULL,
  `enroll_date` varchar(20) DEFAULT NULL,
  `member_id` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`enrollment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `enrollments`
--

LOCK TABLES `enrollments` WRITE;
/*!40000 ALTER TABLE `enrollments` DISABLE KEYS */;
INSERT INTO `enrollments` VALUES ('E001','C002','2025-06-01','M001'),('E002','C002','2025-06-01','M002'),('E003','C003','2025-06-02','M003'),('E004','C004','2025-06-03','M005'),('E005','C003','2025-06-04','M002'),('E006','C004','2026-04-28','GUEST-123'),('E007','C004','2026-04-28','GUEST-7418');
/*!40000 ALTER TABLE `enrollments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exercises`
--

DROP TABLE IF EXISTS `exercises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exercises` (
  `id` varchar(10) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `description` text,
  `equipment` varchar(100) DEFAULT NULL,
  `muscle_group` varchar(50) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `styles` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercises`
--

LOCK TABLES `exercises` WRITE;
/*!40000 ALTER TABLE `exercises` DISABLE KEYS */;
INSERT INTO `exercises` VALUES ('E001','focus','Trains controlled side bending for core control and coordination through slow, precise movement.','bodyweight','abs','90 Degree Alternate Heel Touch','Core|HIIT|Bodybuilding'),('E002','focus','Builds controlled side-to-side core tension, helping improve stability and coordination.','bodyweight','abs','90 Degree Heel Touch','Core|HIIT|Bodybuilding'),('E003','goals','Bodyweight core exercise combining controlled rotation with steady tension to build strength and endurance.','bodyweight','abs','Abdominal Air Bike','Cardio|HIIT|Crossfit'),('E004','goals','Simple core exercise that builds control and endurance using small side-to-side movements under tension.','bodyweight','abs','Alternate Heel Touchers','Core|Endurance|HIIT'),('E005','goals','Controlled core exercise that builds strength and stability by lifting one leg at a time while staying steady.','bodyweight','abs','Alternate Leg Raise','Core|Endurance|HIIT'),('E006','build','Builds arm strength by lifting one weight at a time, improving control and balance between sides.','dumbbell','arms','Alternate Standing Dumbbell Curl','Strength|Bodybuilding'),('E007','build','Basic arm exercise that builds strength and size by lifting a bar through a controlled bending motion.','barbell','arms','Barbell Curl','Strength|Bodybuilding'),('E008','build','Powerful compound exercise that builds back strength, improves posture and supports overall pulling performance.','barbell','back','Barbell Bent Over Row','Strength|Bodybuilding|Powerlifting'),('E009','build','Controlled bodyweight exercise that strengthens the lower back while improving balance and core control.','stability','back','Back Extension On Stability Ball','Strength|Core|Recovery'),('E010','focus','Helps build pulling strength by reducing bodyweight resistance, making it easier to learn proper pull-up technique.','machine','back','Assisted Pull-Up','Strength|Bodybuilding|HIIT'),('E011','build','Foundational chest exercise used to build upper-body pushing strength with a barbell on a flat bench.','barbell','chest','Barbell Bench Press','Strength|Powerlifting|Bodybuilding'),('E012','build','Chest exercise that emphasizes upper chest strength by pressing a barbell on an inclined bench.','barbell','chest','Barbell Incline Bench Press','Strength|Bodybuilding|Powerlifting'),('E013','build','Chest exercise that emphasizes lower chest strength using a barbell on a downward-sloping bench.','barbell','chest','Barbell Decline Bench Press','Strength|Bodybuilding'),('E014','build','Push-up variation that increases upper-body strength by adding band resistance to the pressing movement.','band','chest','Band Resisted Push Up','Strength|HIIT|Bodybuilding'),('E015','goals','Mobility exercise used to open the chest and front shoulders, supporting better posture and smoother shoulder movement.','bodyweight','chest','Back Pec Stretch','Stretching|Mobility|Recovery'),('E016','build','Compound lower-body strength exercise that builds glute power through loaded hip extension.','barbell','glutes','Barbell Hip Thrust','Strength|Bodybuilding|Powerlifting'),('E017','build','Lower-body strength exercise that builds glute power and tension through band resistance.','band','glutes','Banded Hip Thrusts','Strength|Bodybuilding|HIIT'),('E018','build','Foundational strength exercise that builds full-body power and proper lifting mechanics.','barbell','legs','Barbell Deadlift','Strength|Powerlifting|Bodybuilding'),('E019','build','Lower-body strength exercise that builds quad strength while reinforcing an upright, stable squat position.','barbell','legs','Barbell Front Squat','Strength|Powerlifting|Bodybuilding'),('E020','build','Compound lower-body exercise that builds leg strength, balance and control through unilateral loading.','barbell','legs','Barbell Lunge','Strength|Bodybuilding|HIIT'),('E021','build','Hinge-based exercise that strengthens the hamstrings, glutes and lower back while reinforcing proper hip mechanics.','barbell','legs','Barbell Good Morning','Strength|Powerlifting'),('E022','focus','Full-body conditioning movement that uses steady pedaling and pushing to build stamina and work capacity.','machine','legs','Assault Bike Run','Endurance|Cardio|HIIT|Crossfit'),('E023','focus','Explosive full-body lift that builds power, coordination and total-body strength in one fluid movement.','barbell','legs','Barbell Clean And Jerk','Strength|Crossfit|Powerlifting'),('E024','goals','Improves hip mobility and control by guiding your hips through a stable, seated rotation position.','bodyweight','legs','90/90 Stretch','Stretching|Mobility|Recovery'),('E025','goals','Simple recovery exercise that helps reduce stiffness and improve comfort in the front of the leg.','bodyweight','legs','Ball Rolling for Front Thigh','Stretching|Mobility|Recovery'),('E026','build','Builds shoulder strength and control by lifting a fixed bar through a controlled front-to-shoulder range.','barbell','shoulders','Barbell Front Raise','Strength|Bodybuilding');
/*!40000 ALTER TABLE `exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fitness_classes`
--

DROP TABLE IF EXISTS `fitness_classes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fitness_classes` (
  `class_id` varchar(10) NOT NULL,
  `capacity` int DEFAULT NULL,
  `class_name` varchar(100) NOT NULL,
  `enrolled` int DEFAULT NULL,
  `schedule` varchar(50) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `trainer_id` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`class_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_classes`
--

LOCK TABLES `fitness_classes` WRITE;
/*!40000 ALTER TABLE `fitness_classes` DISABLE KEYS */;
INSERT INTO `fitness_classes` VALUES ('C002',25,'Evening Cardio',25,'Tue 18:00','FULL','T002'),('C003',15,'Strength Training',15,'Wed 09:00','FULL','T001'),('C004',30,'Zumba Dance',12,'Thu 17:00','OPEN','T003'),('C005',20,'Weekend HIIT',19,'Sat 08:00','OPEN','T002');
/*!40000 ALTER TABLE `fitness_classes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `members`
--

DROP TABLE IF EXISTS `members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `members` (
  `dtype` varchar(31) NOT NULL,
  `id` varchar(10) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `join_date` varchar(20) DEFAULT NULL,
  `membership_plan_id` varchar(10) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `locker_number` int DEFAULT NULL,
  `personal_trainer_id` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `members`
--

LOCK TABLES `members` WRITE;
/*!40000 ALTER TABLE `members` DISABLE KEYS */;
INSERT INTO `members` VALUES ('STANDARD','M001','john.doe@mail.com','John Doe','0771234567','2025-01-15','P002',NULL,'ACTIVE','STANDARD',NULL,NULL),('STANDARD','M002','sarah.perera@mail.com','Sarah Perera','0779876543','2025-02-01','P003',NULL,'ACTIVE','PREMIUM',NULL,NULL),('STANDARD','M003','kasun.silva@gmail.com','Kasun Silva','0701122334','2025-03-10','P001',NULL,'ACTIVE','STANDARD',NULL,NULL),('STANDARD','M004','nimasha@mail.com','Nimasha Fernando','0762233445','2025-04-05','P002',NULL,'INACTIVE','STANDARD',NULL,NULL),('STANDARD','M005','lakshan@mail.com','Lakshan Wijesinghe','0753344556','2025-04-20','P003',NULL,'ACTIVE','PREMIUM',NULL,NULL),('STANDARD','M006','dinesh.r@mail.com','Dinesh Rajapakse','0741122339','2026-04-22','FREE_TRIAL',NULL,'ACTIVE','TRIAL',NULL,NULL),('STANDARD','M007','priya.j@mail.com','Priya Jayasuriya','0782233448','2026-04-22','P002',NULL,'ACTIVE','STANDARD',NULL,NULL),('STANDARD','M008','admin@gmail.com','Sachin','0742586617','2026-04-28','FREE_TRIAL','admin123','ACTIVE','TRIAL',NULL,NULL);
/*!40000 ALTER TABLE `members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `membership_plans`
--

DROP TABLE IF EXISTS `membership_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `membership_plans` (
  `plan_id` varchar(10) NOT NULL,
  `class_access` varchar(20) DEFAULT NULL,
  `duration_days` int DEFAULT NULL,
  `features` text,
  `plan_name` varchar(100) NOT NULL,
  `price` double DEFAULT NULL,
  PRIMARY KEY (`plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `membership_plans`
--

LOCK TABLES `membership_plans` WRITE;
/*!40000 ALTER TABLE `membership_plans` DISABLE KEYS */;
INSERT INTO `membership_plans` VALUES ('FREE_TRIAL','LIMITED',7,'Gym Access|Locker','Free Trial',0),('P001','LIMITED',30,'Gym Access|Locker|Shower','Basic Monthly',2500),('P002','UNLIMITED',30,'Gym Access|Locker|Shower|Group Classes|Sauna','Standard Monthly',4500),('P003','UNLIMITED',30,'Gym Access|Locker|Shower|All Classes|Sauna|Personal Trainer|Nutrition Advice','Premium Monthly',7500);
/*!40000 ALTER TABLE `membership_plans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplements`
--

DROP TABLE IF EXISTS `supplements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplements` (
  `id` varchar(10) NOT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `category` varchar(50) DEFAULT NULL,
  `description` text,
  `image_url` text,
  `in_stock` bit(1) DEFAULT NULL,
  `name` varchar(200) NOT NULL,
  `price` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplements`
--

LOCK TABLES `supplements` WRITE;
/*!40000 ALTER TABLE `supplements` DISABLE KEYS */;
INSERT INTO `supplements` VALUES ('S001','Optimum Nutrition','Protein','24g protein per serving. The world\'s best-selling whey protein powder for over 20 years.','https://m.media-amazon.com/images/I/71pDSJalaqL._AC_SL1500_.jpg',_binary '','ON Gold Standard Whey','8500.00'),('S002','MuscleTech','Creatine','5g pure creatine per serving. Enhances strength, power, and muscle recovery.','https://m.media-amazon.com/images/I/71RzMSms1CL._AC_SL1500_.jpg',_binary '','MuscleTech Creatine Monohydrate','3200.00'),('S003','Cellucor','Pre-Workout','Explosive energy, heightened focus and an overwhelming urge to crush your workout.','https://m.media-amazon.com/images/I/71oaPFfMg3L._AC_SL1500_.jpg',_binary '','C4 Original Pre-Workout','5500.00'),('S004','Scivation','BCAA','7g BCAAs per serving. Sugar-free intra-workout for muscle recovery and hydration.','https://m.media-amazon.com/images/I/71uZnpzN02L._AC_SL1500_.jpg',_binary '','Scivation Xtend BCAA','4800.00'),('S005','Optimum Nutrition','Mass Gainer','1250 calories per serving with 50g protein. Perfect for hard gainers.','https://m.media-amazon.com/images/I/71Bfv3mRJ4L._AC_SL1500_.jpg',_binary '','ON Serious Mass Gainer','9500.00'),('S006','Cellucor','Fat Burner','Thermogenic fat burner with green tea extract. Boosts metabolism and energy.','https://m.media-amazon.com/images/I/61GmN2MfenL._AC_SL1500_.jpg',_binary '\0','Cellucor SuperHD','4200.00'),('S007','NOW Sports','Vitamins','High potency Vitamin D3 for bone health, immunity, and muscle function.','https://m.media-amazon.com/images/I/71ZbMYBHzBL._AC_SL1500_.jpg',_binary '','NOW Vitamin D3 5000 IU','1800.00'),('S008','BSN','Protein','22g protein per serving with ultra-premium protein matrix. Amazing taste.','https://m.media-amazon.com/images/I/71QhHXGbxzL._AC_SL1500_.jpg',_binary '','BSN Syntha-6 Protein','7200.00');
/*!40000 ALTER TABLE `supplements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trainers`
--

DROP TABLE IF EXISTS `trainers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trainers` (
  `id` varchar(10) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `certifications` text,
  `specialization` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trainers`
--

LOCK TABLES `trainers` WRITE;
/*!40000 ALTER TABLE `trainers` DISABLE KEYS */;
INSERT INTO `trainers` VALUES ('T001','ashan.j@fcms.lk','Ashan Jayawardena','0771001001','NSCA Certified|CPR Certified','Strength Training|Bodybuilding'),('T002','kasun.b@fcms.lk','Kasun Bandara','0772002002','ACE Certified|CPR Certified','Cardio|HIIT'),('T003','nadeesha.p@fcms.lk','Nadeesha Perera','0773003003','Zumba Instructor|ACE Certified','Zumba|Dance Fitness');
/*!40000 ALTER TABLE `trainers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-28 14:09:01
