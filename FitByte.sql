-- Do not trust Github's UI / VSCode when they show syntax errors - they are wrong. Run this with mySQL.
-- Author: Aditya Vikram Khandelwal

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`User` (
  `userID` INT NOT NULL AUTO_INCREMENT,
  `userName` VARCHAR(45) NOT NULL,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(45) NOT NULL,
  `emailAddress` VARCHAR(45) NOT NULL,
  `photo` BLOB NULL,
  `sex` ENUM('M', 'F') NOT NULL,
  `dateJoined` DATETIME NOT NULL,
  `isPublic` TINYINT NOT NULL DEFAULT 1,
  `calorieTarget` INT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE INDEX `uniqueUsername_UNIQUE` (`userName` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`DailyTarget`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`DailyTarget` (
  `dailyTargetID` INT NOT NULL,
  `carbohydrate` INT NULL,
  `fat` INT NULL,
  `protein` INT NULL,
  `glassOfWater` INT NULL,
  `dateSetTarget` DATETIME NOT NULL,
  `userID` INT NOT NULL,
  PRIMARY KEY (`dailyTargetID`),
  INDEX `fk_DailyTarget_User1_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_DailyTarget_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`ReminderAndPrompt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ReminderAndPrompt` (
  `reminderPromptsID` INT NOT NULL,
  `dateSent` TIMESTAMP NOT NULL,
  `type` ENUM('Food', 'Water') NOT NULL COMMENT 'Type - R means reminderto enter information into the food diary  was sent, P means a prompt to drink water was sent',
  `userID` INT NOT NULL,
  PRIMARY KEY (`reminderPromptsID`),
  INDEX `fk_ReminderAndPrompt_User1_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_ReminderAndPrompt_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`UnprocessedFood`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`UnprocessedFood` (
  `unprocessedFoodID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `calories` INT NOT NULL,
  `protein` INT NOT NULL,
  `fat` INT NOT NULL,
  `carbohydrates` INT NOT NULL,
  `sodium` INT NOT NULL,
  PRIMARY KEY (`unprocessedFoodID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`ProcessedFood`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ProcessedFood` (
  `processedFoodID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `calories` INT NOT NULL,
  `protein` INT NOT NULL,
  `fat` INT NOT NULL,
  `carbohydrates` INT NOT NULL,
  `sodium` INT NOT NULL,
  `barcode` BLOB NOT NULL,
  `userAdded` INT NOT NULL,
  PRIMARY KEY (`processedFoodID`),
  INDEX `fk_ProcessedFood_User1_idx` (`userAdded` ASC) VISIBLE,
  CONSTRAINT `fk_ProcessedFood_User1`
    FOREIGN KEY (`userAdded`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`PreparedFood`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PreparedFood` (
  `preparedFoodID` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `retailer` VARCHAR(45) NOT NULL,
  `calories` INT NOT NULL,
  `protein` INT NOT NULL,
  `fat` INT NOT NULL,
  `carbohydrates` INT NOT NULL,
  `sodium` INT NOT NULL,
  PRIMARY KEY (`preparedFoodID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`CustomFood`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`CustomFood` (
  `customFoodID` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `calories` INT NOT NULL,
  `protein` INT NOT NULL,
  `fat` INT NOT NULL,
  `carbohydrates` INT NOT NULL,
  `sodium` INT NOT NULL,
  `userID` INT NOT NULL,
  `date` DATETIME NOT NULL,
  PRIMARY KEY (`customFoodID`),
  INDEX `fk_CustomFood_User1_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_CustomFood_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`FoodDiary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FoodDiary` (
  `foodDairyID` INT NOT NULL AUTO_INCREMENT,
  `userID` INT NOT NULL,
  `category` ENUM('Breakfast', 'Lunch', 'Dinner', 'Snacks') NOT NULL,
  `date` DATETIME NOT NULL,
  `grossCalorie` INT NOT NULL,
  `netCalorie` INT NOT NULL,
  `foodDiaryEntryID` INT NOT NULL COMMENT 'Stores what the person ate',
  PRIMARY KEY (`foodDairyID`),
  INDEX `fk_FoodDairy_User1_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_FoodDairy_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`FoodDiaryEntry`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`FoodDiaryEntry` (
  `foodDiaryEntryID` INT NOT NULL AUTO_INCREMENT,
  `unprocessedFoodID` INT NOT NULL,
  `processedFoodID` INT NOT NULL,
  `preparedFoodID` INT NOT NULL,
  `customerAddID` INT NOT NULL,
  `foodDairyID` INT NOT NULL,
  PRIMARY KEY (`foodDiaryEntryID`),
  INDEX `fk_FoodDatabase_UnprocessedFood1_idx` (`unprocessedFoodID` ASC) VISIBLE,
  INDEX `fk_FoodDatabase_PprocessedFood1_idx` (`processedFoodID` ASC) VISIBLE,
  INDEX `fk_FoodDatabase_PreparedFood1_idx` (`preparedFoodID` ASC) VISIBLE,
  INDEX `fk_FoodDatabase_CustomerAdd1_idx` (`customerAddID` ASC) VISIBLE,
  INDEX `fk_FoodDiaryEntry_FoodDairy1_idx` (`foodDairyID` ASC) VISIBLE,
  CONSTRAINT `fk_FoodDatabase_UnprocessedFood1`
    FOREIGN KEY (`unprocessedFoodID`)
    REFERENCES `mydb`.`UnprocessedFood` (`unprocessedFoodID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FoodDatabase_PprocessedFood1`
    FOREIGN KEY (`processedFoodID`)
    REFERENCES `mydb`.`ProcessedFood` (`processedFoodID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FoodDatabase_PreparedFood1`
    FOREIGN KEY (`preparedFoodID`)
    REFERENCES `mydb`.`PreparedFood` (`preparedFoodID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FoodDatabase_CustomerAdd1`
    FOREIGN KEY (`customerAddID`)
    REFERENCES `mydb`.`CustomFood` (`customFoodID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_FoodDiaryEntry_FoodDairy1`
    FOREIGN KEY (`foodDairyID`)
    REFERENCES `mydb`.`FoodDiary` (`foodDairyID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`WeightHistory`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`WeightHistory` (
  `weightHistoryID` INT NOT NULL AUTO_INCREMENT,
  `goalWeight` FLOAT NOT NULL,
  `currentWeight` FLOAT NOT NULL,
  `userID` INT NOT NULL,
  `date` DATETIME NOT NULL,
  PRIMARY KEY (`weightHistoryID`),
  INDEX `fk_WeightHistory_User1_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_WeightHistory_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`BlogPost`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`BlogPost` (
  `blogPostID` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `postContent` VARCHAR(300) NULL COMMENT 'Contains the blog post made by the user (text part)',
  `vlogContent` LONGBLOB NULL COMMENT 'Contains the VLOG post made by user - the video part.',
  `userID` INT NOT NULL,
  PRIMARY KEY (`blogPostID`),
  INDEX `fk_BlogPost_User1_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_BlogPost_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`PostLikes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PostLikes` (
  `blogPostID` INT NOT NULL,
  `userID` INT NOT NULL COMMENT 'ID of the user who liked the post',
  `date` DATETIME NOT NULL,
  INDEX `fk_PostLikes_User3_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_PostLikes_BlogPost1`
    FOREIGN KEY (`blogPostID`)
    REFERENCES `mydb`.`BlogPost` (`blogPostID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PostLikes_User3`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`ForumPost`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ForumPost` (
  `forumPostID` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `category` ENUM('General', 'Motivation', 'Food Ideas', 'Inspiration', 'Problem Solving') NOT NULL,
  `topic` VARCHAR(45) NOT NULL,
  `postText` VARCHAR(300) NOT NULL,
  `posterID` INT NOT NULL,
  PRIMARY KEY (`forumPostID`),
  INDEX `fk_ForumPost_User2_idx` (`posterID` ASC) VISIBLE,
  CONSTRAINT `fk_ForumPost_User2`
    FOREIGN KEY (`posterID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`ForumPostReply`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ForumPostReply` (
  `forumPostReplyID` INT NOT NULL,
  `replyText` VARCHAR(300) NOT NULL,
  `date` DATETIME NOT NULL,
  `postID` INT NOT NULL,
  `replierID` INT NOT NULL,
  PRIMARY KEY (`forumPostReplyID`),
  INDEX `fk_ForumPostReply_ForumPost1_idx` (`postID` ASC) VISIBLE,
  INDEX `fk_ForumPostReply_User2_idx` (`replierID` ASC) VISIBLE,
  CONSTRAINT `fk_ForumPostReply_ForumPost1`
    FOREIGN KEY (`postID`)
    REFERENCES `mydb`.`ForumPost` (`forumPostID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ForumPostReply_User2`
    FOREIGN KEY (`replierID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Mate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Mate` (
  `mateID` INT NOT NULL,
  `recieverID` INT NOT NULL,
  `senderID` INT NOT NULL,
  `invitationDate` DATETIME NOT NULL,
  `hasAccepted` TINYINT NOT NULL DEFAULT 0 COMMENT '1 if reuest was accepted, 0 if not accepted, default = 0',
  `acceptanceDate` DATETIME NULL COMMENT 'Will be NULL is friendship request hasn\'t been accepted yet',
  `unfriendDate` DATETIME NULL COMMENT 'Will be NULL if Unfriend command was never used',
  `unfriendedBy` TINYINT NULL COMMENT 'NULL if unfriending was never done, 0 if unfriended by the person who had the sent the request (RequestSender) and 1 if unfriended by the person who had accepted the request (RequestReciever)',
  PRIMARY KEY (`mateID`),
  INDEX `fk_Mate_User3_idx` (`recieverID` ASC) VISIBLE,
  INDEX `fk_Mate_User4_idx` (`senderID` ASC) VISIBLE,
  CONSTRAINT `fk_Mate_User3`
    FOREIGN KEY (`recieverID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Mate_User4`
    FOREIGN KEY (`senderID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`PersonalMessage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`PersonalMessage` (
  `messageID` INT NOT NULL,
  `senderID` INT NOT NULL,
  `recieverID` INT NOT NULL,
  `messageText` VARCHAR(140) NOT NULL,
  `date` DATETIME NOT NULL,
  PRIMARY KEY (`messageID`),
  INDEX `fk_PersonalMessage_User3_idx` (`senderID` ASC) VISIBLE,
  INDEX `fk_PersonalMessage_User4_idx` (`recieverID` ASC) VISIBLE,
  CONSTRAINT `fk_PersonalMessage_User3`
    FOREIGN KEY (`senderID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_PersonalMessage_User4`
    FOREIGN KEY (`recieverID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Report`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Report` (
  `reportID` INT NOT NULL,
  `complainerID` INT NOT NULL,
  `complaineeID` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `contactEmail` VARCHAR(45) NOT NULL,
  `contactPhone` VARCHAR(45) NOT NULL,
  `statement` VARCHAR(100) NOT NULL COMMENT 'NULL if complaint was a \"BLOCK\" request. Application will force this field to be not NULL if complain is of \"REPORT\" type.',
  PRIMARY KEY (`reportID`),
  INDEX `fk_Complaint_User3_idx` (`complainerID` ASC) VISIBLE,
  INDEX `fk_Complaint_User4_idx` (`complaineeID` ASC) VISIBLE,
  CONSTRAINT `fk_Complaint_User3`
    FOREIGN KEY (`complainerID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Complaint_User4`
    FOREIGN KEY (`complaineeID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`ExcerciseDatabase`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ExcerciseDatabase` (
  `excerciseID` INT NOT NULL,
  `excerciseName` VARCHAR(45) NOT NULL,
  `calorie/HourMale` INT NOT NULL,
  `calorie/HourFemale` INT NOT NULL,
  PRIMARY KEY (`excerciseID`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`ExcerciseDiary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ExcerciseDiary` (
  `entryID` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `excerciseID` INT NOT NULL,
  `userID` INT NOT NULL,
  `excerciseDuration` INT NOT NULL,
  `caloriesBurnt` INT NOT NULL,
  PRIMARY KEY (`entryID`),
  INDEX `fk_ExcerciseDiary_ExcerciseDB1_idx` (`excerciseID` ASC) VISIBLE,
  INDEX `fk_ExcerciseDiary_User2_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_ExcerciseDiary_ExcerciseDB1`
    FOREIGN KEY (`excerciseID`)
    REFERENCES `mydb`.`ExcerciseDatabase` (`excerciseID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ExcerciseDiary_User2`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`RunningEnergyAverage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`RunningEnergyAverage` (
  `runningEnergyAverageID` INT NOT NULL,
  `net3dayAverage` INT NOT NULL,
  `sum3dayAverage` INT NOT NULL,
  `net7dayAverage` INT NULL COMMENT 'can be NULL if user has not yet completed using the app for at least 7 days',
  `sum7dayAverage` INT NULL COMMENT 'can be NULL if user has not yet completed using the app for at least 7 days',
  `netMonthAverage` INT NULL COMMENT 'can be NULL if user has not yet completed using the app for at least a month',
  `sumMonthAverage` INT NULL COMMENT 'can be NULL if user has not yet completed using the app for at least a month',
  `calendarMonth` INT NULL COMMENT 'can be NULL if user has not yet completed using the app for at least a month',
  `date` DATETIME NOT NULL,
  `userID` INT NOT NULL,
  PRIMARY KEY (`runningEnergyAverageID`),
  INDEX `fk_RunningEnergyAverage_TEST_User1_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_RunningEnergyAverage_TEST_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`Block`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Block` (
  `blockID` INT NOT NULL,
  `complainerID` INT NOT NULL,
  `complaineeID` INT NOT NULL,
  `date` DATETIME NOT NULL,
  PRIMARY KEY (`blockID`),
  INDEX `fk_Block_User1_idx` (`complainerID` ASC) VISIBLE,
  INDEX `fk_Block_User2_idx` (`complaineeID` ASC) VISIBLE,
  CONSTRAINT `fk_Block_User1`
    FOREIGN KEY (`complainerID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Block_User2`
    FOREIGN KEY (`complaineeID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `mydb`.`DailyDiary`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`DailyDiary` (
  `dailyDiaryID` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `grossCalorie` INT NOT NULL,
  `caloriesBurnt` INT NOT NULL,
  `netCalorie` INT NOT NULL,
  `userID` INT NOT NULL,
  PRIMARY KEY (`dailyDiaryID`),
  INDEX `fk_DailyDiary_User1_idx` (`userID` ASC) VISIBLE,
  CONSTRAINT `fk_DailyDiary_User1`
    FOREIGN KEY (`userID`)
    REFERENCES `mydb`.`User` (`userID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `mydb` ;
