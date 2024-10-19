-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 19, 2024 at 03:16 PM
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
-- Database: `bankingdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `account_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `account_type` enum('savings','checking') NOT NULL,
  `balance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`account_id`, `user_id`, `account_type`, `balance`, `created_at`, `updated_at`, `status`) VALUES
(1, 2, 'savings', 1489.00, '2024-10-18 15:28:02', '2024-10-19 11:41:07', 'closed'),
(2, 3, 'checking', 2013.00, '2024-10-18 15:28:02', '2024-10-19 11:44:36', 'Active'),
(3, 2, 'checking', 2499.00, '2024-10-18 15:28:02', '2024-10-19 11:45:09', 'closed'),
(4, 3, 'savings', 3000.00, '2024-10-18 15:28:02', '2024-10-18 15:28:02', ''),
(5, 2, 'savings', 500.00, '2024-10-18 15:28:02', '2024-10-18 15:28:02', '');

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `bill_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `bill_type` varchar(50) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `due_date` date NOT NULL,
  `status` enum('paid','unpaid') DEFAULT 'unpaid',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bills`
--

INSERT INTO `bills` (`bill_id`, `user_id`, `bill_type`, `amount`, `due_date`, `status`, `created_at`) VALUES
(1, 2, 'Electricity', 100.00, '2024-10-30', 'unpaid', '2024-10-18 15:28:02'),
(2, 3, 'Water', 50.00, '2024-10-28', 'paid', '2024-10-18 15:28:02'),
(3, 2, 'Internet', 30.00, '2024-10-25', 'unpaid', '2024-10-18 15:28:02'),
(4, 3, 'Phone', 40.00, '2024-10-20', 'paid', '2024-10-18 15:28:02'),
(5, 2, 'Credit Card', 200.00, '2024-11-05', 'unpaid', '2024-10-18 15:28:02');

-- --------------------------------------------------------

--
-- Table structure for table `loans`
--

CREATE TABLE `loans` (
  `loan_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `loan_amount` decimal(15,2) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `loan_status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `loan_type` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `loans`
--

INSERT INTO `loans` (`loan_id`, `user_id`, `loan_amount`, `interest_rate`, `loan_status`, `created_at`, `updated_at`, `loan_type`) VALUES
(1, 2, 5000.00, 5.50, 'approved', '2024-10-18 15:28:02', '2024-10-18 15:28:02', ''),
(2, 3, 3000.00, 4.50, 'approved', '2024-10-18 15:28:02', '2024-10-19 10:58:37', ''),
(3, 2, 7000.00, 6.00, 'approved', '2024-10-18 15:28:02', '2024-10-18 15:28:02', ''),
(4, 3, 2000.00, 5.00, 'rejected', '2024-10-18 15:28:02', '2024-10-18 15:28:02', ''),
(5, 2, 4500.00, 5.20, 'approved', '2024-10-18 15:28:02', '2024-10-19 11:30:17', ''),
(6, 2, 100.00, 5.00, 'rejected', '2024-10-19 07:32:15', '2024-10-19 10:59:02', 'personal'),
(7, 2, 1.00, 5.00, 'approved', '2024-10-19 11:34:35', '2024-10-19 12:30:34', 'personal'),
(8, 2, 1.00, 5.00, 'pending', '2024-10-19 11:35:11', '2024-10-19 11:35:11', 'personal'),
(9, 2, 1.00, 5.00, 'pending', '2024-10-19 11:35:19', '2024-10-19 11:35:19', 'personal');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `transaction_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `transaction_type` enum('deposit','withdrawal','transfer') NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `transaction_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`transaction_id`, `account_id`, `transaction_type`, `amount`, `transaction_date`, `status`) VALUES
(1, 1, 'deposit', 1000.00, '2024-10-18 15:28:02', 'approved'),
(2, 2, 'withdrawal', 500.00, '2024-10-18 15:28:02', 'approved'),
(3, 1, 'transfer', 300.00, '2024-10-18 15:28:02', 'approved'),
(4, 2, 'deposit', 700.00, '2024-10-18 15:28:02', ''),
(5, 3, 'withdrawal', 200.00, '2024-10-18 15:28:02', '');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','customer','employee') NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `role`, `email`, `phone`, `created_at`, `updated_at`) VALUES
(1, 'admin1', 'hashed_password1', 'admin', 'admin1@example.com', '1234567890', '2024-10-18 15:28:02', '2024-10-18 15:28:02'),
(2, 'customer1r', 'hashed_password2', 'customer', 'customer1@example.com', '1234567891', '2024-10-18 15:28:02', '2024-10-19 11:38:58'),
(3, 'customer2', 'hashed_password3', 'customer', 'customer2@example.com', '1234567892', '2024-10-18 15:28:02', '2024-10-18 15:28:02'),
(4, 'employee1', 'hashed_password4', 'employee', 'employee1@example.com', '1234567893', '2024-10-18 15:28:02', '2024-10-18 15:28:02'),
(5, 'employee2', 'hashed_password5', 'employee', 'employee2@example.com', '1234567894', '2024-10-18 15:28:02', '2024-10-18 15:28:02');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`account_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`bill_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`loan_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`transaction_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `loans`
--
ALTER TABLE `loans`
  MODIFY `loan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
