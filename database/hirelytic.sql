-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 05, 2026 at 03:34 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12
SET
  SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

START TRANSACTION;

SET
  time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;

/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;

/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;

/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hirelytic`
--
-- --------------------------------------------------------
--
-- Table structure for table `candidates`
--
CREATE TABLE
  `candidates` (
    `candidateID` int (11) NOT NULL,
    `uploadID` int (11) DEFAULT NULL,
    `fileName` text DEFAULT NULL,
    `educationLevel` text DEFAULT NULL,
    `yearsExperience` int (11) DEFAULT NULL,
    `compatibilityScore` int (11) DEFAULT NULL,
    `analysisText` text NOT NULL,
    `rejectionReasons` text DEFAULT NULL
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `candidates`
--
INSERT INTO
  `candidates` (
    `candidateID`,
    `uploadID`,
    `fileName`,
    `educationLevel`,
    `yearsExperience`,
    `compatibilityScore`,
    `analysisText`,
    `rejectionReasons`
  )
VALUES
  (
    2501,
    127,
    'resumes_ResumeAnte_Inna.pdf',
    'Bachelor',
    18,
    90,
    'Highly experienced nurse with 18 years of experience in various healthcare settings, including hospitals and rural health units, with a strong background in patient care and nursing practices.',
    NULL
  ),
  (
    2502,
    133,
    'resumes_ResumeAnte_Inna.pdf',
    'Bachelor',
    16,
    90,
    'Experienced nurse with 16 years of experience in various healthcare settings, including hospitals and rural health units, with a strong background in patient care and nursing practices.',
    NULL
  ),
  (
    2503,
    134,
    'resumes_ResumeAnte_Inna.pdf',
    'Bachelor\'s Degree',
    18,
    100,
    'The applicant meets all the requirements for the Nurse position, having a Bachelor\'s Degree in Nursing and more than 2 years of experience in patient care, including specific experience with animal bite care.',
    NULL
  ),
  (
    2504,
    135,
    'resumes_ResumeAnte_Inna.pdf',
    'Bachelor\'s Degree',
    14,
    1,
    'The applicant, Myrna Bautista Estrada, has a Bachelor\'s Degree in Nursing and 14 years of experience in patient care, including experience with animal bites. She has relevant training and seminars attended, and her work experience aligns with the job requirements. She is a strong candidate for the Nurse position.',
    NULL
  ),
  (
    2505,
    136,
    'resumes_ResumeAnte_Inna.pdf',
    'Bachelor\'s Degree',
    18,
    100,
    'The applicant, Myrna Bautista Estrada, meets all the requirements for the Nurse position, with a Bachelor\'s Degree in Nursing and over 2 years of experience, specifically 18 years of experience in patient care and animal bite care.',
    NULL
  ),
  (
    2506,
    137,
    'resumes_ResumeAnte_Inna.pdf',
    'Bachelor\'s Degree',
    18,
    1,
    'The applicant, Myrna Bautista Estrada, meets all the requirements for the Nurse position, with a Bachelor\'s Degree in Nursing and over 2 years of experience. She also possesses the required skills in patient care and animal bite care, as evident from her training and work experience.',
    NULL
  ),
  (
    2507,
    137,
    'resumes_Resume-melvs.pdf',
    'Bachelor\'s Degree (currently pursuing)',
    0,
    0,
    'The candidate is currently pursuing a Bachelor\'s Degree and has no relevant experience in patient care or animal bite care. The candidate\'s skills do not match the required skills for the nurse position.',
    NULL
  ),
  (
    2508,
    138,
    'resumes_ResumeAnte_Inna.pdf',
    'Bachelor\'s Degree',
    18,
    1,
    'The applicant, Myrna Bautista Estrada, has a Bachelor\'s Degree in Nursing and 18 years of experience in the field. She has the required skills of patient care and animal bite care, and has worked in various healthcare settings, including hospitals and rural health units. Her experience as an RHU Night Shift Nurse and her training in Rabies and Animal Bite Management make her a strong candidate for the position.',
    NULL
  ),
  (
    2509,
    138,
    'resumes_Resume-melvs.pdf',
    'Incomplete',
    0,
    0,
    'The candidate does not meet the minimum requirements for the job. The candidate\'s education is incomplete, with no degree mentioned, and there is no relevant work experience or skills listed that match the job requirements.',
    NULL
  ),
  (
    2510,
    144,
    'ResumeAnte_Inna.pdf',
    'Bachelor\'s Degree',
    14,
    95,
    'Strong overall match',
    '[]'
  ),
  (
    2511,
    145,
    'ResumeAnte_Inna.pdf',
    'Bachelor\'s Degree',
    18,
    95,
    'Strong overall match',
    '[]'
  ),
  (
    2512,
    145,
    'Resume-melvs.pdf',
    'College',
    0,
    0,
    'No relevant experience, skills, or education',
    '[\"missing required skills: Patient care, Animal Bite care, Basic nursing skills\", \"insufficient experience: 0 years, required 2 years\", \"unmet education: Bachelor\'s Degree not completed\"]'
  ),
  (
    2513,
    146,
    'ResumeAnte_Inna.pdf',
    'Bachelor\'s Degree',
    18,
    95,
    'Strong overall match',
    '[]'
  ),
  (
    2514,
    147,
    'ResumeAnte_Inna.pdf',
    'Bachelor\'s Degree',
    6,
    95,
    'Strong candidate with matching skills and experience.',
    '[]'
  ),
  (
    2515,
    147,
    'Resume-melvs.pdf',
    'Incomplete Bachelor\'s Degree',
    0,
    0,
    'No relevant experience, skills, or education.',
    '[\"Missing required skills: Patient care, Animal Bite care, Basic nursing skills\", \"Insufficient experience: 0 years, required 2 years\", \"Unmet education: Incomplete Bachelor\'s Degree, required Bachelor\'s Degree\"]'
  );

-- --------------------------------------------------------
--
-- Table structure for table `candidate_skills`
--
CREATE TABLE
  `candidate_skills` (
    `skillID` int (11) NOT NULL,
    `candidateID` int (11) DEFAULT NULL,
    `skillName` text DEFAULT NULL
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `candidate_skills`
--
INSERT INTO
  `candidate_skills` (`skillID`, `candidateID`, `skillName`)
VALUES
  (1, 2501, 'Nursing'),
  (2, 2501, 'Patient Care'),
  (3, 2501, 'Medicine Administration'),
  (4, 2501, 'Vital Signs Monitoring'),
  (5, 2502, 'Nursing'),
  (6, 2502, 'Patient Care'),
  (7, 2502, 'Medicine Administration'),
  (8, 2503, 'Patient care'),
  (9, 2503, 'Animal Bite care'),
  (10, 2504, 'Patient care'),
  (11, 2504, 'Animal Bite'),
  (12, 2505, 'Patient care'),
  (13, 2505, 'Animal Bite care'),
  (14, 2506, 'Patient care'),
  (15, 2506, 'Animal Bite care'),
  (16, 2507, 'Communication Skills'),
  (17, 2507, 'Retentive Memory'),
  (18, 2507, 'Optimistic'),
  (19, 2508, 'Patient care'),
  (20, 2508, 'Animal Bite care'),
  (21, 2509, 'Communication Skills'),
  (22, 2509, 'Retentive Memory'),
  (23, 2509, 'Optimistic'),
  (24, 2510, 'Patient care'),
  (25, 2510, 'Animal Bite care'),
  (26, 2510, 'Basic nursing skills'),
  (27, 2511, 'Patient care'),
  (28, 2511, 'Animal Bite care'),
  (29, 2511, 'Basic nursing skills'),
  (30, 2512, 'Patient care'),
  (31, 2512, 'Animal Bite care'),
  (32, 2512, 'Basic nursing skills'),
  (33, 2513, 'Patient care'),
  (34, 2513, 'Animal Bite care'),
  (35, 2513, 'Basic nursing skills'),
  (36, 2514, 'Patient care'),
  (37, 2514, 'Animal Bite care'),
  (38, 2514, 'Basic nursing skills'),
  (39, 2515, 'Patient care'),
  (40, 2515, 'Animal Bite care'),
  (41, 2515, 'Basic nursing skills');

-- --------------------------------------------------------
--
-- Table structure for table `roles`
--
CREATE TABLE
  `roles` (
    `roleID` int (11) NOT NULL,
    `roleName` varchar(50) NOT NULL
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--
INSERT INTO
  `roles` (`roleID`, `roleName`)
VALUES
  (1, 'Admin'),
  (2, 'hr');

-- --------------------------------------------------------
--
-- Table structure for table `uploads`
--
CREATE TABLE
  `uploads` (
    `uploadID` int (11) NOT NULL,
    `userID` int (11) DEFAULT NULL,
    `jobTitle` text DEFAULT NULL,
    `requiredSkills` text DEFAULT NULL,
    `educationalRequirement` text DEFAULT NULL,
    `experienceRequirement` text DEFAULT NULL,
    `uploadDate` datetime DEFAULT NULL,
    `processingTime` int (11) NOT NULL,
    `analysisDate` int (11) NOT NULL
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `uploads`
--
INSERT INTO
  `uploads` (
    `uploadID`,
    `userID`,
    `jobTitle`,
    `requiredSkills`,
    `educationalRequirement`,
    `experienceRequirement`,
    `uploadDate`,
    `processingTime`,
    `analysisDate`
  )
VALUES
  (
    127,
    8,
    NULL,
    NULL,
    NULL,
    NULL,
    '2025-11-03 15:08:53',
    4,
    20251103
  ),
  (
    133,
    8,
    'Nurse',
    'Patient care, Animal Bite care',
    NULL,
    '2',
    '2026-01-03 09:07:47',
    4,
    20260103
  ),
  (
    134,
    8,
    'Nurse',
    'Patient care, Animal Bite care',
    'Bachelor\'s Degree',
    '2',
    '2026-01-03 09:38:45',
    6,
    20260103
  ),
  (
    135,
    8,
    'Nurse',
    'Patient care, Animal Bite',
    'Bachelor\'s Degree',
    '2',
    '2026-01-03 09:58:09',
    6,
    20260103
  ),
  (
    136,
    8,
    'Nurse',
    'Patient care, Animal Bite care',
    'Bachelor\'s Degree',
    '2',
    '2026-01-03 10:12:15',
    6,
    20260103
  ),
  (
    137,
    8,
    'Nurse',
    'Patient care, Animal Bite care',
    'Bachelor\'s Degree',
    '2',
    '2026-01-05 09:16:43',
    15,
    20260105
  ),
  (
    138,
    8,
    'Nurse',
    'Patient care, Animal Bite care',
    'Bachelor\'s Degree',
    '2',
    '2026-01-05 09:18:06',
    9,
    20260105
  ),
  (
    139,
    8,
    'Nurse',
    'Patient care, Animal Bite care, Basic nursing skills',
    'Bachelor\'s Degree',
    '2',
    '2026-01-05 09:34:50',
    0,
    0
  ),
  (
    140,
    8,
    'Nurse',
    'Patient care, Animal Bite care, Basic nursing skills',
    'Bachelor\'s Degree',
    '2',
    '2026-01-05 09:41:33',
    0,
    0
  ),
  (
    141,
    8,
    'Nurse',
    'Patient care, Animal Bite care, Basic nursing skills',
    'Bachelor\'s Degree',
    '2',
    '2026-01-05 10:14:59',
    0,
    0
  ),
  (
    142,
    8,
    'Nurse',
    'Patient care, Animal Bite care, Basic nursing skills',
    'Bachelor\'s Degree',
    '2',
    '2026-01-05 10:20:34',
    0,
    0
  ),
  (
    143,
    8,
    'Nurse',
    'Patient care, Animal Bite care, Basic nursing skills',
    'Bachelor\'s Degree',
    '2',
    '2026-01-05 10:21:49',
    0,
    0
  ),
  (
    144,
    8,
    'Nurse',
    'Patient care, Animal Bite care, Basic nursing skills',
    'Bachelor\'s Degree',
    '2',
    '2026-01-05 10:24:18',
    6,
    20260105
  ),
  (
    145,
    8,
    'Nurse',
    'Patient care, Animal Bite care, Basic nursing skills',
    'Bachelor\'s Degree',
    '2',
    '2026-01-05 10:26:39',
    8,
    20260105
  ),
  (
    146,
    8,
    'Nurse',
    'Patient care, Animal Bite care, Basic nursing skills',
    'Bachelor\'s Degree',
    '2',
    '2026-01-05 10:30:42',
    5,
    20260105
  ),
  (
    147,
    8,
    'Nurse',
    'Patient care, Animal Bite care, Basic nursing skills',
    'Bachelor\'s Degree',
    '2',
    '2026-01-05 10:33:12',
    11,
    20260105
  );

-- --------------------------------------------------------
--
-- Table structure for table `users`
--
CREATE TABLE
  `users` (
    `UserID` int (20) NOT NULL,
    `userName` varchar(50) DEFAULT NULL,
    `email` varchar(20) DEFAULT NULL,
    `passwordHash` varchar(255) NOT NULL,
    `createdAT` datetime DEFAULT current_timestamp(),
    `roleID` int (11) DEFAULT NULL
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

--
-- Dumping data for table `users`
--
INSERT INTO
  `users` (
    `UserID`,
    `userName`,
    `email`,
    `passwordHash`,
    `createdAT`,
    `roleID`
  )
VALUES
  (
    7,
    'budoy',
    'juliolalax@gmail.com',
    'scrypt:32768:8:1$R6i95YeO1lAEWRN7$532d3b38fd13b8cdb13a2a9e0936b36dc0171c43f950da433c78eaed13f419c997fb827432a026a2935e13fe38c99341de9ed0ba489154604e92df252561ab7b',
    '2025-11-18 15:51:33',
    NULL
  ),
  (
    8,
    'admin',
    'test@gmail.com',
    'scrypt:32768:8:1$ayUBnJejpMbvZYx9$ff18e693b036c536f632ba24d98bc5f1bd7034e321cc911366b883a2731733a2f01b9af1413b597ad3b6edd42388bfda98315d4acd564f66c74096d76e02a96e',
    '2025-11-18 16:16:05',
    NULL
  ),
  (
    9,
    'Xedrik',
    'julioxedrik@gmail.co',
    'scrypt:32768:8:1$El8hy2uDkq8xZ4TF$7481666fb8f2431256f2d6835a2a3d30ac5eb4b69bf0c1a6ebfbc369f9461e01c25374893e159007823c7617fdbd86e167c67240b17f36f9765ce3e140f5aee8',
    '2025-11-25 16:00:35',
    NULL
  ),
  (
    10,
    'Diddy',
    'Oilup@gmail.com',
    'scrypt:32768:8:1$0qIToVMdIjK4xujd$bb65b8e196c1e0ec6c82d998362d4b777f4c9009c9cf51694eafdc7233374792460d79af6cb784a9af6e9603a1138bc75cd9a0864bee27af9465056cef2958c0',
    '2025-12-28 11:27:19',
    NULL
  );

--
-- Indexes for dumped tables
--
--
-- Indexes for table `candidates`
--
ALTER TABLE `candidates` ADD PRIMARY KEY (`candidateID`),
ADD KEY `uploadID` (`uploadID`);

--
-- Indexes for table `candidate_skills`
--
ALTER TABLE `candidate_skills` ADD PRIMARY KEY (`skillID`),
ADD KEY `candidateID` (`candidateID`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles` ADD PRIMARY KEY (`roleID`),
ADD UNIQUE KEY `roleName` (`roleName`);

--
-- Indexes for table `uploads`
--
ALTER TABLE `uploads` ADD PRIMARY KEY (`uploadID`),
ADD KEY `usID` (`userID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users` ADD PRIMARY KEY (`UserID`),
ADD KEY `fkUserRole` (`roleID`);

--
-- AUTO_INCREMENT for dumped tables
--
--
-- AUTO_INCREMENT for table `candidates`
--
ALTER TABLE `candidates` MODIFY `candidateID` int (11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 2516;

--
-- AUTO_INCREMENT for table `candidate_skills`
--
ALTER TABLE `candidate_skills` MODIFY `skillID` int (11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 42;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles` MODIFY `roleID` int (11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 3;

--
-- AUTO_INCREMENT for table `uploads`
--
ALTER TABLE `uploads` MODIFY `uploadID` int (11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 148;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users` MODIFY `UserID` int (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 11;

--
-- Constraints for dumped tables
--
--
-- Constraints for table `candidates`
--
ALTER TABLE `candidates` ADD CONSTRAINT `candidates_ibfk_1` FOREIGN KEY (`uploadID`) REFERENCES `uploads` (`uploadID`);

--
-- Constraints for table `candidate_skills`
--
ALTER TABLE `candidate_skills` ADD CONSTRAINT `candidate_skills_ibfk_1` FOREIGN KEY (`candidateID`) REFERENCES `candidates` (`candidateID`);

--
-- Constraints for table `uploads`
--
ALTER TABLE `uploads` ADD CONSTRAINT `uploads_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `users`
--
ALTER TABLE `users` ADD CONSTRAINT `fkUserRole` FOREIGN KEY (`roleID`) REFERENCES `roles` (`roleID`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;

/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;