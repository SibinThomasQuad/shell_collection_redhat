#!/bin/bash

# Source MySQL database details
SOURCE_DB_HOST="localhost"
SOURCE_DB_USER="root"
SOURCE_DB_PASS="password"
SOURCE_DB_NAME="a1"

# Destination MySQL database details
DEST_DB_HOST="localhost"
DEST_DB_USER="root"
DEST_DB_PASS="password"
DEST_DB_NAME="a3"

# Dump the source database
echo "Dumping source database..."
mysqldump -h "$SOURCE_DB_HOST" -u "$SOURCE_DB_USER" -p"$SOURCE_DB_PASS" "$SOURCE_DB_NAME" > source_db_dump.sql

# Check if the dump was successful
if [ $? -eq 0 ]; then
    echo "Source database dump created successfully: source_db_dump.sql"

    # Restore the dump into the destination database
    echo "Restoring dump into destination database..."
    mysql -h "$DEST_DB_HOST" -u "$DEST_DB_USER" -p"$DEST_DB_PASS" "$DEST_DB_NAME" < source_db_dump.sql

    # Check if the restore was successful
    if [ $? -eq 0 ]; then
        echo "Dump restored successfully into destination database."
    else
        echo "Dump restore failed."
    fi
else
    echo "Source database dump failed."
fi

# Clean up the dump file
rm source_db_dump.sql
