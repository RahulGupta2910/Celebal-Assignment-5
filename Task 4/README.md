# Objective:
Perform a selective data migration by copying specific tables and columns from a source database (celebal_source) to a target database (celebal_destination). This approach supports business-driven data transfer requirements, compliance, and storage efficiency.

## 📌 Key Features
Accepts source database, destination database, and a JSON map of tables and column selections as input.

Dynamically validates if columns exist in the source schema before attempting copy.

Creates target tables using the selected columns only.

Skips invalid columns with warnings and continues gracefully.

Fully automated — creates databases, handles missing tables, and performs data transfer.

Final summary of all copied tables and skipped operations included.
