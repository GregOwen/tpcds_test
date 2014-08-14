#!/bin/bash

usage="run_queries /path/to/beeline select_dir"
if [ "$#" -ne 3 ]; then
 echo "Usage: $usage"
fi

BEELINE=$1
SELECT_DIR=$2

BEELINE_OPTS="-u jdbc:hive2://localhost:10000 -n `whoami` -p ignored"
TABLE_CONFIG="
set spark.sql.autoBroadcastJoinThreshold=52428800;\n
set spark.sql.hive.convertMetastoreParquet=true;\n
set spark.sql.parquet.binaryAsString=true;\n
set spark.sql.codegen=true;\n
"

TOTAL_OUT=$($BEELINE $BEELINE_OPTS -e "select count(*) from store_sales;" | tail -2 | head -1)
TOTAL_ROWS=$(echo $TOTAL_OUT | sed 's/[\s\|]//g')
   
HEADER="query file | rows accessed | row fraction"

# Run test
for file in $( ls $SELECT_DIR ); do
    echo Running $file

    # Prepare the temp file with all set options
    tmpfile=$(mktemp)
    echo -e $TABLE_CONFIG > $tmpfile
    cat $SELECT_DIR/$file >> $tmpfile

    # Find number of rows selected
    count_out=$($BEELINE $BEELINE_OPTS -f $tmpfile | tail -3 | head -1)
    count=$(echo $count_out | sed 's/[\s\|]//g')
    frac=$(bc -l <<< "$count/$TOTAL_ROWS")

    echo $HEADER
    echo -e "$file\t$count\t$frac"
done
