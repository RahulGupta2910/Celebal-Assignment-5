USE celebal_source;
drop procedure IF EXISTS selective_database_copy;
DELIMITER //

CREATE PROCEDURE selective_database_copy(
    IN source_db VARCHAR(64),
    IN dest_db VARCHAR(64),
    IN table_map JSON  -- Format: {"table1": ["col1", "col2"], "table2": ["colA", "colB"]}
)
BEGIN
    DECLARE is_complete INT DEFAULT FALSE;
    DECLARE table_name VARCHAR(64);
    DECLARE col_list TEXT;
    DECLARE col_name VARCHAR(64);
    DECLARE i INT DEFAULT 0;
    DECLARE col_count INT DEFAULT 0;
    DECLARE tables_copied INT DEFAULT 0;
    
-- Cursor to loop through table names that exist in the source
    DECLARE cur CURSOR FOR
        SELECT t.table_name
        FROM temp_tables t
        INNER JOIN information_schema.tables ist
        ON t.table_name = ist.table_name
        WHERE ist.table_schema = source_db;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET is_complete = TRUE;

    -- Prepare a temporary table to hold table names from JSON
    DROP TEMPORARY TABLE IF EXISTS temp_tables;
    CREATE TEMPORARY TABLE temp_tables (table_name VARCHAR(64));

    -- Extract table names from the input JSON
    SET @table_keys = JSON_KEYS(table_map);
    SET @table_count = JSON_LENGTH(@table_keys);

    WHILE i < @table_count DO
        SET table_name = JSON_UNQUOTE(JSON_EXTRACT(@table_keys, CONCAT('$[', i, ']')));
        INSERT INTO temp_tables VALUES (table_name);
        SET i = i + 1;
    END WHILE;

    -- Create the destination database if it doesn't already exist
    SET @sql = CONCAT('CREATE DATABASE IF NOT EXISTS `', dest_db, '`');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;

    -- Temporarily turn off foreign key checks
    SET FOREIGN_KEY_CHECKS = 0;

    OPEN cur;

    while_loop: LOOP
        FETCH cur INTO table_name;
        IF is_complete THEN
            LEAVE while_loop;
        END IF;

        -- Reset column tracking
        SET col_list = '';
        SET i = 0;
        SET col_count = JSON_LENGTH(JSON_EXTRACT(table_map, CONCAT('$."', table_name, '"')));

        -- Gather the valid columns for the current table
        WHILE i < col_count DO
            SET col_name = JSON_UNQUOTE(JSON_EXTRACT(
                JSON_EXTRACT(table_map, CONCAT('$."', table_name, '"')),
                CONCAT('$[', i, ']')
            ));

            -- Check if column exists in source
            SET @col_exists = 0;
            SET @sql = CONCAT(
                'SELECT COUNT(*) INTO @col_exists FROM information_schema.columns ',
                'WHERE table_schema = ''', source_db, ''' ',
                'AND table_name = ''', table_name, ''' ',
                'AND column_name = ''', col_name, ''''
            );
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            IF @col_exists > 0 THEN
                SET col_list = CONCAT(col_list, IF(col_list = '', '', ', '), '`', col_name, '`');
            ELSE
                SELECT CONCAT('Warning: Column "', col_name, '" not found in "', table_name, '"') AS warning;
            END IF;

            SET i = i + 1;
        END WHILE;

        -- Proceed only if valid columns were found
        IF col_list != '' THEN
            -- Drop table in destination if it already exists
            SET @sql = CONCAT('DROP TABLE IF EXISTS `', dest_db, '`.`', table_name, '`');
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            -- Create table structure using selected columns
            SET @sql = CONCAT(
                'CREATE TABLE `', dest_db, '`.`', table_name, '` ',
                'SELECT ', col_list, ' FROM `', source_db, '`.`', table_name, '` WHERE 1=0'
            );
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            DEALLOCATE PREPARE stmt;

            -- Copy data
            SET @sql = CONCAT(
                'INSERT INTO `', dest_db, '`.`', table_name, '` (', col_list, ') ',
                'SELECT ', col_list, ' FROM `', source_db, '`.`', table_name, '`'
            );
            PREPARE stmt FROM @sql;
            EXECUTE stmt;
            SET @rows_copied = ROW_COUNT();
            DEALLOCATE PREPARE stmt;

            SELECT CONCAT('Copied "', table_name, '" [', col_list, '] — ', @rows_copied, ' rows') AS status;
            SET tables_copied = tables_copied + 1;
        ELSE
            SELECT CONCAT('Skipped "', table_name, '" - No valid columns found') AS warning;
        END IF;
    END LOOP;

    CLOSE cur;

    -- Re-enable foreign key checks
    SET FOREIGN_KEY_CHECKS = 1;

    -- Clean up temp table
    DROP TEMPORARY TABLE IF EXISTS temp_tables;

    -- Final summary
    SELECT CONCAT(
        'Selective copy complete: ', 
        tables_copied, ' table(s) copied'
    ) AS summary;
END //

DELIMITER ;

CALL selective_database_copy(
    'celebal_source',
    'celebal_destination',
    '{
        "departments": ["id", "name", "location"],
        "products": ["product_id", "product_name", "price", "in_stock"]
    }'
);

USE celebal_destination;
SHOW TABLES;
SELECT * FROM departments;
SELECT * FROM products;
