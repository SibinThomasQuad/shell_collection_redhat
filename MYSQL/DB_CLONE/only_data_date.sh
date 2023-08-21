#!/bin/bash

# MySQL database details
DB_HOST="localhost"
DB_USER="root"
DB_PASS="info@123"
DB_NAME="a1"

# Array of tables and their corresponding date columns
# Format: "table_name:date_column"
TABLES=(
    "sales:sale_date"
)

# Output file for all data dumps
ALL_DUMPS_FILE="all_data_dumps.sql"

# Specific date for filtering data in the format YYYY-MM-DD
DATE_TO_DUMP="2023-08-20"

# Clear or create the all dumps file
> "$ALL_DUMPS_FILE"

# Iterate over each table in the array
for table in "${TABLES[@]}"; do
    IFS=':' read -ra TABLE_INFO <<< "$table"
    TABLE_NAME="${TABLE_INFO[0]}"
    DATE_COLUMN="${TABLE_INFO[1]}"

    # Create a temporary file for the SQL query
    SQL_FILE=$(mktemp)

    # Write the SQL query to the temporary file
    echo "SELECT * FROM \`$TABLE_NAME\` WHERE \`$DATE_COLUMN\` = '$DATE_TO_DUMP';" > "$SQL_FILE"

    # Take data dump of the table using the SQL query
    echo "Taking data dump of $TABLE_NAME for $DATE_TO_DUMP..."

    mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" --no-create-info --skip-add-drop-table "$DB_NAME" < "$SQL_FILE" >> "$ALL_DUMPS_FILE"

    # Check if the data dump was successful
    if [ $? -eq 0 ]; then
        echo "Data dump created successfully for $TABLE_NAME."
    else
        echo "Data dump failed for $TABLE_NAME."
    fi

    # Remove the temporary SQL file
    rm "$SQL_FILE"
done
