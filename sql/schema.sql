-- Admin To-Do System Database Schema
-- Compatible with MySQL and MariaDB

CREATE TABLE IF NOT EXISTS `admin_tasks` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(255) DEFAULT NULL,
    `description` TEXT NOT NULL,
    `created_by` VARCHAR(100) NOT NULL,
    `created_by_name` VARCHAR(100) DEFAULT NULL,
    `assigned_to` VARCHAR(100) DEFAULT NULL,
    `assigned_to_name` VARCHAR(100) DEFAULT NULL,
    `status` ENUM('pending', 'completed') DEFAULT 'pending',
    `priority` ENUM('low', 'normal', 'high', 'urgent', 'started') DEFAULT 'normal',
    `date_created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `date_completed` DATETIME DEFAULT NULL,
    `completed_by` VARCHAR(100) DEFAULT NULL,
    `completed_by_name` VARCHAR(100) DEFAULT NULL,
    `reopen_reason` TEXT DEFAULT NULL,
    `resource` VARCHAR(100) DEFAULT NULL,
    `position_x` DECIMAL(10, 4) DEFAULT NULL,
    `position_y` DECIMAL(10, 4) DEFAULT NULL,
    `position_z` DECIMAL(10, 4) DEFAULT NULL,
    `position_heading` DECIMAL(10, 4) DEFAULT NULL,
    PRIMARY KEY (`id`),
    INDEX `idx_status` (`status`),
    INDEX `idx_priority` (`priority`),
    INDEX `idx_created_by` (`created_by`),
    INDEX `idx_assigned_to` (`assigned_to`),
    INDEX `idx_resource` (`resource`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Admin Chat Messages Table
CREATE TABLE IF NOT EXISTS `admin_chat_messages` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `author_name` VARCHAR(100) NOT NULL,
    `message` TEXT NOT NULL,
    `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

