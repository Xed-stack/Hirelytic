-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 03, 2025 at 06:47 AM
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
-- Table structure for table `analysis_candidates`
--
CREATE TABLE
  `analysis_candidates` (
    `id` int (11) NOT NULL,
    `summary_id` int (11) DEFAULT NULL,
    `file_id` int (11) DEFAULT NULL,
    `rank` int (11) DEFAULT NULL,
    `candidate_name` varchar(255) DEFAULT NULL,
    `compatibility_score` decimal(5, 2) DEFAULT NULL,
    `key_skills` text DEFAULT NULL,
    `education_level` varchar(100) DEFAULT NULL,
    `experience_text` varchar(255) DEFAULT NULL
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `analysis_summary`
--
CREATE TABLE
  `analysis_summary` (
    `summary_id` int (11) NOT NULL,
    `job_id` int (11) DEFAULT NULL,
    `batch_id` varchar(50) DEFAULT NULL,
    `total_resumes` int (11) DEFAULT NULL,
    `avg_compatibility` decimal(5, 2) DEFAULT NULL,
    `processing_time_seconds` int (11) DEFAULT NULL,
    `top_skill_match` varchar(100) DEFAULT NULL,
    `rejected_count` int (11) DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp()
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `analysis_text_insights`
--
CREATE TABLE
  `analysis_text_insights` (
    `insight_id` int (11) NOT NULL,
    `summary_id` int (11) DEFAULT NULL,
    `insight_text` text DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp()
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `analytics_history`
--
CREATE TABLE
  `analytics_history` (
    `analytics_id` int (11) NOT NULL,
    `job_id` int (11) DEFAULT NULL,
    `total_candidates` int (11) DEFAULT NULL,
    `eligible_count` int (11) DEFAULT NULL,
    `rejected_count` int (11) DEFAULT NULL,
    `avg_score` decimal(5, 2) DEFAULT NULL,
    `top_missing_skills` text DEFAULT NULL,
    `top_skills` text DEFAULT NULL,
    `top_certifications` text DEFAULT NULL,
    `month_year` varchar(10) DEFAULT NULL,
    `generated_at` timestamp NOT NULL DEFAULT current_timestamp()
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `candidate_evaluation`
--
CREATE TABLE
  `candidate_evaluation` (
    `evaluation_id` int (11) NOT NULL,
    `file_id` int (11) DEFAULT NULL,
    `job_id` int (11) DEFAULT NULL,
    `skill_score` decimal(5, 2) DEFAULT NULL,
    `education_score` decimal(5, 2) DEFAULT NULL,
    `experience_score` decimal(5, 2) DEFAULT NULL,
    `certification_score` decimal(5, 2) DEFAULT NULL,
    `total_score` decimal(5, 2) DEFAULT NULL,
    `candidate_status` varchar(50) DEFAULT NULL,
    `missing_skills` text DEFAULT NULL,
    `notes` text DEFAULT NULL,
    `evaluated_at` timestamp NOT NULL DEFAULT current_timestamp()
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `candidate_files`
--
CREATE TABLE
  `candidate_files` (
    `file_id` int (11) NOT NULL,
    `candidate_name` varchar(255) DEFAULT NULL,
    `email` varchar(255) DEFAULT NULL,
    `original_filename` varchar(255) DEFAULT NULL,
    `saved_path` varchar(500) DEFAULT NULL,
    `upload_date` timestamp NOT NULL DEFAULT current_timestamp(),
    `job_id` int (11) DEFAULT NULL
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `education_distribution`
--
CREATE TABLE
  `education_distribution` (
    `dist_id` int (11) NOT NULL,
    `summary_id` int (11) DEFAULT NULL,
    `education_level` varchar(100) DEFAULT NULL,
    `count` int (11) DEFAULT NULL
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `job_requirements`
--
CREATE TABLE
  `job_requirements` (
    `job_id` int (11) NOT NULL,
    `job_title` varchar(255) DEFAULT NULL,
    `required_skills` text DEFAULT NULL,
    `required_education` varchar(100) DEFAULT NULL,
    `min_experience_years` int (11) DEFAULT NULL,
    `required_certifications` text DEFAULT NULL,
    `required_languages` text DEFAULT NULL,
    `required_tools` text DEFAULT NULL,
    `created_at` timestamp NOT NULL DEFAULT current_timestamp()
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

-- --------------------------------------------------------
--
-- Table structure for table `resume_extracted`
--
CREATE TABLE
  `resume_extracted` (
    `resume_id` int (11) NOT NULL,
    `file_id` int (11) DEFAULT NULL,
    `raw_text` longtext DEFAULT NULL,
    `extracted_skills` text DEFAULT NULL,
    `extracted_education` varchar(255) DEFAULT NULL,
    `years_experience` int (11) DEFAULT NULL,
    `extracted_certifications` text DEFAULT NULL,
    `extracted_languages` text DEFAULT NULL,
    `extracted_tools` text DEFAULT NULL
  ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_general_ci;

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
  );

--
-- Indexes for dumped tables
--
--
-- Indexes for table `analysis_candidates`
--
ALTER TABLE `analysis_candidates` ADD PRIMARY KEY (`id`),
ADD KEY `summary_id` (`summary_id`),
ADD KEY `file_id` (`file_id`);

--
-- Indexes for table `analysis_summary`
--
ALTER TABLE `analysis_summary` ADD PRIMARY KEY (`summary_id`),
ADD KEY `job_id` (`job_id`);

--
-- Indexes for table `analysis_text_insights`
--
ALTER TABLE `analysis_text_insights` ADD PRIMARY KEY (`insight_id`),
ADD KEY `summary_id` (`summary_id`);

--
-- Indexes for table `analytics_history`
--
ALTER TABLE `analytics_history` ADD PRIMARY KEY (`analytics_id`),
ADD KEY `job_id` (`job_id`);

--
-- Indexes for table `candidate_evaluation`
--
ALTER TABLE `candidate_evaluation` ADD PRIMARY KEY (`evaluation_id`),
ADD KEY `file_id` (`file_id`),
ADD KEY `job_id` (`job_id`);

--
-- Indexes for table `candidate_files`
--
ALTER TABLE `candidate_files` ADD PRIMARY KEY (`file_id`),
ADD KEY `job_id` (`job_id`);

--
-- Indexes for table `education_distribution`
--
ALTER TABLE `education_distribution` ADD PRIMARY KEY (`dist_id`),
ADD KEY `summary_id` (`summary_id`);

--
-- Indexes for table `job_requirements`
--
ALTER TABLE `job_requirements` ADD PRIMARY KEY (`job_id`);

--
-- Indexes for table `resume_extracted`
--
ALTER TABLE `resume_extracted` ADD PRIMARY KEY (`resume_id`),
ADD KEY `file_id` (`file_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles` ADD PRIMARY KEY (`roleID`),
ADD UNIQUE KEY `roleName` (`roleName`);

--
-- Indexes for table `users`
--
ALTER TABLE `users` ADD PRIMARY KEY (`UserID`),
ADD KEY `fkUserRole` (`roleID`);

--
-- AUTO_INCREMENT for dumped tables
--
--
-- AUTO_INCREMENT for table `analysis_candidates`
--
ALTER TABLE `analysis_candidates` MODIFY `id` int (11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `analysis_summary`
--
ALTER TABLE `analysis_summary` MODIFY `summary_id` int (11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `analysis_text_insights`
--
ALTER TABLE `analysis_text_insights` MODIFY `insight_id` int (11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `analytics_history`
--
ALTER TABLE `analytics_history` MODIFY `analytics_id` int (11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `candidate_evaluation`
--
ALTER TABLE `candidate_evaluation` MODIFY `evaluation_id` int (11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `candidate_files`
--
ALTER TABLE `candidate_files` MODIFY `file_id` int (11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `education_distribution`
--
ALTER TABLE `education_distribution` MODIFY `dist_id` int (11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `job_requirements`
--
ALTER TABLE `job_requirements` MODIFY `job_id` int (11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `resume_extracted`
--
ALTER TABLE `resume_extracted` MODIFY `resume_id` int (11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles` MODIFY `roleID` int (11) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users` MODIFY `UserID` int (20) NOT NULL AUTO_INCREMENT,
AUTO_INCREMENT = 10;

--
-- Constraints for dumped tables
--
--
-- Constraints for table `analysis_candidates`
--
ALTER TABLE `analysis_candidates` ADD CONSTRAINT `analysis_candidates_ibfk_1` FOREIGN KEY (`summary_id`) REFERENCES `analysis_summary` (`summary_id`),
ADD CONSTRAINT `analysis_candidates_ibfk_2` FOREIGN KEY (`file_id`) REFERENCES `candidate_files` (`file_id`);

--
-- Constraints for table `analysis_summary`
--
ALTER TABLE `analysis_summary` ADD CONSTRAINT `analysis_summary_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `job_requirements` (`job_id`);

--
-- Constraints for table `analysis_text_insights`
--
ALTER TABLE `analysis_text_insights` ADD CONSTRAINT `analysis_text_insights_ibfk_1` FOREIGN KEY (`summary_id`) REFERENCES `analysis_summary` (`summary_id`);

--
-- Constraints for table `analytics_history`
--
ALTER TABLE `analytics_history` ADD CONSTRAINT `analytics_history_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `job_requirements` (`job_id`);

--
-- Constraints for table `candidate_evaluation`
--
ALTER TABLE `candidate_evaluation` ADD CONSTRAINT `candidate_evaluation_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `candidate_files` (`file_id`),
ADD CONSTRAINT `candidate_evaluation_ibfk_2` FOREIGN KEY (`job_id`) REFERENCES `job_requirements` (`job_id`);

--
-- Constraints for table `candidate_files`
--
ALTER TABLE `candidate_files` ADD CONSTRAINT `candidate_files_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `job_requirements` (`job_id`);

--
-- Constraints for table `education_distribution`
--
ALTER TABLE `education_distribution` ADD CONSTRAINT `education_distribution_ibfk_1` FOREIGN KEY (`summary_id`) REFERENCES `analysis_summary` (`summary_id`);

--
-- Constraints for table `resume_extracted`
--
ALTER TABLE `resume_extracted` ADD CONSTRAINT `resume_extracted_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `candidate_files` (`file_id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users` ADD CONSTRAINT `fkUserRole` FOREIGN KEY (`roleID`) REFERENCES `roles` (`roleID`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;

/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;