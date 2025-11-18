-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 18, 2025 at 09:23 AM
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
(8, 'admin', 'test@gmail.com', 'scrypt:32768:8:1$ayUBnJejpMbvZYx9$ff18e693b036c536f632ba24d98bc5f1bd7034e321cc911366b883a2731733a2f01b9af1413b597ad3b6edd42388bfda98315d4acd564f66c74096d76e02a96e', '2025-11-18 16:16:05', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`roleID`),
  ADD UNIQUE KEY `roleName` (`roleName`);

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
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `roleID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `UserID` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fkUserRole` FOREIGN KEY (`roleID`) REFERENCES `roles` (`roleID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
