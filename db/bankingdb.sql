-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 19, 2024 at 11:34 AM
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
(1, 2, 'savings', 68.00, '2024-10-18 15:28:02', '2024-11-19 03:10:59', 'closed'),
(2, 3, 'checking', 3434.00, '2024-10-18 15:28:02', '2024-11-19 03:10:59', 'Active'),
(3, 2, 'checking', 2499.00, '2024-10-18 15:28:02', '2024-10-19 11:45:09', 'closed'),
(4, 3, 'savings', 3000.00, '2024-10-18 15:28:02', '2024-11-12 06:33:16', 'Active'),
(5, 2, 'savings', 500.00, '2024-10-18 15:28:02', '2024-11-13 12:06:14', 'closed');

-- --------------------------------------------------------

--
-- Table structure for table `atm_card_requests`
--

CREATE TABLE `atm_card_requests` (
  `request_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `card_type` enum('debit','credit') NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `request_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `approved_date` timestamp NULL DEFAULT NULL,
  `contact_number` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `atm_card_requests`
--

INSERT INTO `atm_card_requests` (`request_id`, `user_id`, `account_id`, `card_type`, `status`, `request_date`, `approved_date`, `contact_number`) VALUES
(1, 2, 1, 'debit', 'approved', '2024-11-12 09:23:51', NULL, 1),
(2, 2, 3, 'credit', 'approved', '2024-11-12 09:29:38', NULL, 121212);

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
-- Table structure for table `cheque_book_requests`
--

CREATE TABLE `cheque_book_requests` (
  `request_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `contact_number` varchar(15) NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `request_date` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cheque_book_requests`
--

INSERT INTO `cheque_book_requests` (`request_id`, `user_id`, `account_id`, `contact_number`, `status`, `request_date`) VALUES
(1, 2, 1, '1', 'approved', '2024-11-12 09:40:03');

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
(8, 2, 1.00, 5.00, 'approved', '2024-10-19 11:35:11', '2024-10-23 06:14:01', 'personal'),
(9, 2, 1.00, 5.00, 'rejected', '2024-10-19 11:35:19', '2024-10-23 06:14:05', 'personal'),
(10, 2, 111.00, 5.00, 'approved', '2024-11-12 06:42:52', '2024-11-17 09:13:51', 'home');

-- --------------------------------------------------------

--
-- Table structure for table `session_logs`
--

CREATE TABLE `session_logs` (
  `log_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `session_id` varchar(100) NOT NULL,
  `login_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `logout_time` timestamp NULL DEFAULT NULL,
  `ip_address` varchar(45) NOT NULL,
  `status` enum('active','logged_out') NOT NULL DEFAULT 'active'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `session_logs`
--

INSERT INTO `session_logs` (`log_id`, `user_id`, `session_id`, `login_time`, `logout_time`, `ip_address`, `status`) VALUES
(1, 1, '90AA052167B238C381B83D2D589692B6', '2024-11-18 07:02:21', '2024-11-18 07:04:40', '0:0:0:0:0:0:0:1', 'logged_out'),
(2, 1, 'E482B4C5EACD3FAEF0FD6F51635556A1', '2024-11-18 07:10:25', '2024-11-18 07:12:02', '0:0:0:0:0:0:0:1', 'logged_out'),
(3, 1, 'F48BB1CBDD1BE91A76D33250AE8F01A3', '2024-11-18 07:12:15', '2024-11-18 07:13:13', '0:0:0:0:0:0:0:1', 'logged_out'),
(4, 4, 'E461E701DFA01C4FD4B40B4A925423CE', '2024-11-18 07:13:36', '2024-11-18 07:14:52', '0:0:0:0:0:0:0:1', 'logged_out'),
(5, 2, '8382811F2DD9FF53D3BFAE9AE90EC379', '2024-11-18 07:15:11', '2024-11-18 07:16:19', '0:0:0:0:0:0:0:1', 'logged_out'),
(6, 2, '31C7C92CCF5FB95E444F5304662DAC05', '2024-11-18 07:16:59', '2024-11-18 07:17:25', '0:0:0:0:0:0:0:1', 'logged_out'),
(7, 4, '6A9846CC9487671F8BFFACBAF2CED92E', '2024-11-18 07:17:30', '2024-11-18 07:22:45', '0:0:0:0:0:0:0:1', 'logged_out'),
(9, 2, '280FA9E79A4C70F4F03496F843022CB2', '2024-11-19 02:50:03', '2024-11-19 03:11:30', '0:0:0:0:0:0:0:1', 'logged_out'),
(10, 4, '757853ABE8836B57D0F1530503758861', '2024-11-19 03:11:34', '2024-11-19 03:11:53', '0:0:0:0:0:0:0:1', 'logged_out'),
(11, 1, 'CD559C287F171407345CECE830B76955', '2024-11-19 03:11:57', '2024-11-19 03:12:19', '0:0:0:0:0:0:0:1', 'logged_out'),
(12, 2, '09B6428D2C6BA10B6F0F9D66C62B11C6', '2024-11-19 07:21:54', '2024-11-19 07:22:44', '0:0:0:0:0:0:0:1', 'logged_out'),
(13, 1, '4E69C061E1C143C0DE8BA6EA8B679299', '2024-11-19 07:22:59', '2024-11-19 07:23:00', '0:0:0:0:0:0:0:1', 'logged_out'),
(14, 4, 'E717EB49DB7FBDE43E4837BD4B414EEF', '2024-11-19 07:23:07', '2024-11-19 07:24:01', '0:0:0:0:0:0:0:1', 'logged_out'),
(15, 1, '111611DF41DFB468CD2846769EC17737', '2024-11-19 07:24:05', '2024-11-19 07:25:56', '0:0:0:0:0:0:0:1', 'logged_out');

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
(4, 2, 'deposit', 700.00, '2024-10-18 15:28:02', 'approved'),
(5, 3, 'withdrawal', 200.00, '2024-10-18 15:28:02', 'approved'),
(6, 1, 'withdrawal', 1221.00, '2024-11-19 03:10:59', 'approved');

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
(1, 'admin1', '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918', 'admin', 'admin1@example.com', '1234567890', '2024-10-18 15:28:02', '2024-11-17 09:38:47'),
(2, 'customer1', 'b6c45863875e34487ca3c155ed145efe12a74581e27befec5aa661b8ee8ca6dd', 'customer', 'customer1@example.com', '1234567891', '2024-10-18 15:28:02', '2024-11-17 09:40:17'),
(3, 'customer2', 'b6c45863875e34487ca3c155ed145efe12a74581e27befec5aa661b8ee8ca6dd', 'customer', 'customer2@example.com', '1234567892', '2024-10-18 15:28:02', '2024-11-17 09:40:28'),
(4, 'employee1', '9d586dc0a48a2ed04839e0a69750893438e8d379e2fa45e94e82c5b3abb00daa', 'employee', 'employee1@example.com', '1234567893', '2024-10-18 15:28:02', '2024-11-18 06:56:32');

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
-- Indexes for table `atm_card_requests`
--
ALTER TABLE `atm_card_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`bill_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `cheque_book_requests`
--
ALTER TABLE `cheque_book_requests`
  ADD PRIMARY KEY (`request_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `account_id` (`account_id`);

--
-- Indexes for table `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`loan_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `session_logs`
--
ALTER TABLE `session_logs`
  ADD PRIMARY KEY (`log_id`),
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
  MODIFY `account_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `atm_card_requests`
--
ALTER TABLE `atm_card_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `bill_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `cheque_book_requests`
--
ALTER TABLE `cheque_book_requests`
  MODIFY `request_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `loans`
--
ALTER TABLE `loans`
  MODIFY `loan_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `session_logs`
--
ALTER TABLE `session_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `accounts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `atm_card_requests`
--
ALTER TABLE `atm_card_requests`
  ADD CONSTRAINT `atm_card_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `atm_card_requests_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE CASCADE;

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `cheque_book_requests`
--
ALTER TABLE `cheque_book_requests`
  ADD CONSTRAINT `cheque_book_requests_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `cheque_book_requests_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`);

--
-- Constraints for table `loans`
--
ALTER TABLE `loans`
  ADD CONSTRAINT `loans_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `session_logs`
--
ALTER TABLE `session_logs`
  ADD CONSTRAINT `session_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
