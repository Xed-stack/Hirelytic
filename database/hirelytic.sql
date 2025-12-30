-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 30, 2025 at 07:39 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


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

CREATE TABLE `candidates` (
  `candidateID` int(11) NOT NULL,
  `uploadID` int(11) DEFAULT NULL,
  `fileName` text DEFAULT NULL,
  `educationLevel` text DEFAULT NULL,
  `yearsExperience` int(11) DEFAULT NULL,
  `compatibilityScore` int(11) DEFAULT NULL,
  `analysisText` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `candidate_skills`
--

CREATE TABLE `candidate_skills` (
  `skillID` int(11) NOT NULL,
  `candidateID` int(11) DEFAULT NULL,
  `skillName` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `roleID` int(11) NOT NULL,
  `roleName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`roleID`, `roleName`) VALUES
(1, 'Admin'),
(2, 'hr');

-- --------------------------------------------------------

--
-- Table structure for table `uploads`
--

CREATE TABLE `uploads` (
  `uploadID` int(11) NOT NULL,
  `userID` int(11) DEFAULT NULL,
  `jobTitle` text DEFAULT NULL,
  `requiredSkills` text DEFAULT NULL,
  `educationalRequirement` text DEFAULT NULL,
  `experienceRequirement` text DEFAULT NULL,
  `uploadDate` datetime DEFAULT NULL,
  `processingTime` int(11) NOT NULL,
  `analysisDate` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `UserID` int(20) NOT NULL,
  `userName` varchar(50) DEFAULT NULL,
  `email` varchar(20) DEFAULT NULL,
  `passwordHash` varchar(255) NOT NULL,
  `createdAT` datetime DEFAULT current_timestamp(),
  `roleID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`UserID`, `userName`, `email`, `passwordHash`, `createdAT`, `roleID`) VALUES
(7, 'budoy', 'juliolalax@gmail.com', 'scrypt:32768:8:1$R6i95YeO1lAEWRN7$532d3b38fd13b8cdb13a2a9e0936b36dc0171c43f950da433c78eaed13f419c997fb827432a026a2935e13fe38c99341de9ed0ba489154604e92df252561ab7b', '2025-11-18 15:51:33', NULL),
(8, 'admin', 'test@gmail.com', 'scrypt:32768:8:1$ayUBnJejpMbvZYx9$ff18e693b036c536f632ba24d98bc5f1bd7034e321cc911366b883a2731733a2f01b9af1413b597ad3b6edd42388bfda98315d4acd564f66c74096d76e02a96e', '2025-11-18 16:16:05', NULL),
(9, 'Xedrik', 'julioxedrik@gmail.co', 'scrypt:32768:8:1$El8hy2uDkq8xZ4TF$7481666fb8f2431256f2d6835a2a3d30ac5eb4b69bf0c1a6ebfbc369f9461e01c25374893e159007823c7617fdbd86e167c67240b17f36f9765ce3e140f5aee8', '2025-11-25 16:00:35', NULL),
(10, 'Diddy', 'Oilup@gmail.com', 'scrypt:32768:8:1$0qIToVMdIjK4xujd$bb65b8e196c1e0ec6c82d998362d4b777f4c9009c9cf51694eafdc7233374792460d79af6cb784a9af6e9603a1138bc75cd9a0864bee27af9465056cef2958c0', '2025-12-28 11:27:19', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `candidates`
--
ALTER TABLE `candidates`
  ADD PRIMARY KEY (`candidateID`),
  ADD KEY `uploadID` (`uploadID`);

--
-- Indexes for table `candidate_skills`
--
ALTER TABLE `candidate_skills`
  ADD PRIMARY KEY (`skillID`),
  ADD KEY `candidateID` (`candidateID`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`roleID`),
  ADD UNIQUE KEY `roleName` (`roleName`);

--
-- Indexes for table `uploads`
--
ALTER TABLE `uploads`
  ADD PRIMARY KEY (`uploadID`),
  ADD KEY `usID` (`userID`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`UserID`),
  ADD KEY `fkUserRole` (`roleID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `candidates`
--
ALTER TABLE `candidates`
  MODIFY `candidateID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2501;

--
-- AUTO_INCREMENT for table `candidate_skills`
--
ALTER TABLE `candidate_skills`
  MODIFY `skillID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `roleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `uploads`
--
ALTER TABLE `uploads`
  MODIFY `uploadID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `candidates`
--
ALTER TABLE `candidates`
  ADD CONSTRAINT `candidates_ibfk_1` FOREIGN KEY (`uploadID`) REFERENCES `uploads` (`uploadID`);

--
-- Constraints for table `candidate_skills`
--
ALTER TABLE `candidate_skills`
  ADD CONSTRAINT `candidate_skills_ibfk_1` FOREIGN KEY (`candidateID`) REFERENCES `candidates` (`candidateID`);

--
-- Constraints for table `uploads`
--
ALTER TABLE `uploads`
  ADD CONSTRAINT `uploads_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`UserID`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fkUserRole` FOREIGN KEY (`roleID`) REFERENCES `roles` (`roleID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
