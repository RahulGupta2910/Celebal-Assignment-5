-- This code connects to source database and drops the procude to copy files

USE celebal_source;
DROP PROCEDURE IF EXISTS copy_tables;
 
DELIMITER //
CREATE PROCEDURE copy_tables(IN source_db VARCHAR(64), IN destination_db VARCHAR(64))
BEGIN
    DECLARE is_complete INT DEFAULT FALSE;
    DECLARE table_to_copy VARCHAR(64);
    DECLARE cur CURSOR FOR 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = source_db;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_complete = TRUE;
    
    -- Check if the destination database exists, if not create destination database 
    SET @create_db_stmt = CONCAT('CREATE DATABASE IF NOT EXISTS `', destination_db, '`');
    PREPARE stmt FROM @create_db_stmt;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
    OPEN cur;
    
    while_loop: LOOP
        FETCH cur INTO table_to_copy;
        IF is_complete THEN
            LEAVE while_loop;
        END IF;
        
		    -- Drop the table in destination if exists and create it

        -- Drop table in destination if exists
        SET @drop_table_stmt = CONCAT('DROP TABLE IF EXISTS `', destination_db, '`.`', table_to_copy, '`');
        PREPARE stmt FROM @drop_table_stmt;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        -- Create table in destination
        SET @create_table_stmt = CONCAT('CREATE TABLE `', destination_db, '`.`', table_to_copy, '` LIKE `', source_db, '`.`', table_to_copy, '`');
        PREPARE stmt FROM @create_table_stmt;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        -- Copy data from source to destination
        SET @copy_data_stmt = CONCAT('INSERT INTO `', destination_db, '`.`', table_to_copy, '` SELECT * FROM `', source_db, '`.`', table_to_copy, '`');
        PREPARE stmt FROM @copy_data_stmt;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SELECT CONCAT('Copied table: ', table_to_copy) AS status;
    END LOOP;
    
    CLOSE cur;
END //
DELIMITER ;

-- Now the following executes the procedure to copy from source to destination
CALL copy_tables('celebal_source', 'celebal_destination');
