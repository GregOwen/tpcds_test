#!/bin/bash

usage="run_queries /path/to/beeline clean_dir pool_name"
if [ "$#" -ne 3 ]; then
 echo "Usage: $usage"
fi

BEELINE=$1
CLEAN_DIR=$2
POOL_NAME=$3

BEELINE_OPTS="-u jdbc:hive2://localhost:10000 -n `whoami` -p ignored"
TABLE_CONFIG="
set spark.sql.autoBroadcastJoinThreshold=52428800;\n
set spark.sql.hive.convertMetastoreParquet=true;\n
set spark.sql.parquet.binaryAsString=true;\n
set spark.sql.codegen=true;\n
set spark.sql.scheduler.pool=$POOL_NAME;\n
"

NUM_TRIALS=5

# Make sure we can do broadcast hash joins
TABLES=(customer customer_address customer_demographics date_dim household_demographics item promotion store time_dim)
for table in ${TABLES[*]}; do
    $BEELINE $BEELINE_OPTS -e "analyze table $table compute statistics noscan;"
done
   
timefile=$(mktemp)
# Run test
for file in $( ls $CLEAN_DIR | shuf ); do
    for i in `seq 1 $NUM_TRIALS`; do
	echo "Running $file ($i of $NUM_TRIALS)"
	
	# Prepare the temp file with all set options
	tmpfile=$(mktemp)
	echo -e $TABLE_CONFIG > $tmpfile
	cat $CLEAN_DIR/$file >> $tmpfile

	# Find output from cleaned file
	output=$(($BEELINE $BEELINE_OPTS -f $tmpfile 1>/dev/null) 2>&1 | tail -2 | head -1)
	time=$(echo "$output" | grep seconds | cut -d "(" -f 2 | cut -d " " -f1)
	echo -e "$file\t$time seconds"
	echo -e "$file\t$time" >> $timefile
    done
    echo ""
done

cat $timefile | sort >> ${timefile}_sorted
echo "Time data is in ${timefile}_sorted"
