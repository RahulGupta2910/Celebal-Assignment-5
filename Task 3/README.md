# Objective:
Perform full database replication by copying all tables and their data from a source database to a target database, ensuring schema and data consistency for backup, migration, or environment sync.

## Approach:

Created a source database celebal_source with two well-structured tables:

departments: Contains metadata about 15 departments including name, location, budget, and creation date.

products: Contains 20 product records across various categories like Stationery, Electronics, and Home.

Used SQL to:

Define identical schemas in the destination (celebal_target) database.

Insert data from source to target using INSERT INTO ... SELECT * FROM approach.

Verified replication using SELECT * queries on both databases.
