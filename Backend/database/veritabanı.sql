-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema mobile_project
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mobile_project
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mobile_project` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `mobile_project` ;

-- -----------------------------------------------------
-- Table `mobile_project`.`categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobile_project`.`categories` (
  `category_id`  NOT NULL,
  `category_name` VARCHAR(45) NULL DEFAULT NULL,
  `icon_name` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`category_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mobile_project`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobile_project`.`users` (
  `user_id`  NOT NULL,
  `full_name` VARCHAR(100) NULL DEFAULT NULL,
  `email` VARCHAR(150) NULL DEFAULT NULL,
  `password` VARCHAR(255) NULL DEFAULT NULL,
  `department` VARCHAR(100) NULL DEFAULT NULL,
  `role` VARCHAR(45) NULL DEFAULT NULL,
  `created_at`  NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mobile_project`.`emergency_alerts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobile_project`.`emergency_alerts` (
  `alert_id`  NOT NULL,
  `title` VARCHAR(100) NULL DEFAULT NULL,
  `message` VARCHAR(100) NULL DEFAULT NULL,
  `sent_at`  NULL DEFAULT NULL,
  `user_id`  NOT NULL,
  PRIMARY KEY (`alert_id`),
  INDEX `fk_emergency_alerts_users1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_emergency_alerts_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mobile_project`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mobile_project`.`reports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobile_project`.`reports` (
  `report_id`  NOT NULL,
  `title` VARCHAR(100) NULL DEFAULT NULL,
  `description` VARCHAR(200) NULL DEFAULT NULL,
  `latitude` DOUBLE NULL DEFAULT NULL,
  `longitude` DOUBLE NULL DEFAULT NULL,
  `status` VARCHAR(45) NULL DEFAULT NULL,
  `created_at`  NULL DEFAULT NULL,
  `updated_at`  NULL DEFAULT NULL,
  `user_id`  NOT NULL,
  `categories_category_id`  NOT NULL,
  PRIMARY KEY (`report_id`),
  INDEX `fk_reports_users_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_reports_categories1_idx` (`categories_category_id` ASC) VISIBLE,
  CONSTRAINT `fk_reports_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `mobile_project`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reports_categories1`
    FOREIGN KEY (`categories_category_id`)
    REFERENCES `mobile_project`.`categories` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mobile_project`.`followed_reports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobile_project`.`followed_reports` (
  `id`  NOT NULL,
  `followed_at`  NULL DEFAULT NULL,
  `user_id`  NOT NULL,
  `report_id`  NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_followed_reports_users1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_followed_reports_reports1_idx` (`report_id` ASC) VISIBLE,
  CONSTRAINT `fk_followed_reports_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mobile_project`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_followed_reports_reports1`
    FOREIGN KEY (`report_id`)
    REFERENCES `mobile_project`.`reports` (`report_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mobile_project`.`notification_settings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobile_project`.`notification_settings` (
  `setting_id`  NOT NULL,
  `is_enabled`  NULL DEFAULT NULL,
  `user_id`  NOT NULL,
  `category_id`  NOT NULL,
  PRIMARY KEY (`setting_id`),
  INDEX `fk_notification_settings_users1_idx` (`user_id` ASC) VISIBLE,
  INDEX `fk_notification_settings_categories1_idx` (`category_id` ASC) VISIBLE,
  CONSTRAINT `fk_notification_settings_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mobile_project`.`users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_notification_settings_categories1`
    FOREIGN KEY (`category_id`)
    REFERENCES `mobile_project`.`categories` (`category_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `mobile_project`.`report_media`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mobile_project`.`report_media` (
  `media_id`  NOT NULL,
  `media_url` VARCHAR(255) NULL DEFAULT NULL,
  `uploaded_at`  NULL DEFAULT NULL,
  `report_id`  NOT NULL,
  PRIMARY KEY (`media_id`),
  INDEX `fk_report_media_reports1_idx` (`report_id` ASC) VISIBLE,
  CONSTRAINT `fk_report_media_reports1`
    FOREIGN KEY (`report_id`)
    REFERENCES `mobile_project`.`reports` (`report_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
