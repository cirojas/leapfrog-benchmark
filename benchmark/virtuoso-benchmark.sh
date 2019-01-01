#!/bin/bash

cd virtuoso
echo starting virtuoso server
virtuoso-opensource/bin/virtuoso-t -c virtuoso.ini
cd ..

sleep 1m

echo warming up
python benchmark.py queries/warmup.txt http://localhost:8890/sparql > /dev/null
echo "[done]"
sleep 1m

for file in $1/*.txt
do
	queryName=$(basename $file)
	echo processing $queryName
	python benchmark.py $1/$queryName http://localhost:8890/sparql > $1/output/${queryName%%.txt}/virtuoso
	echo "[done]"
done

virtuoso/virtuoso-opensource/bin/isql localhost:1111 -K
