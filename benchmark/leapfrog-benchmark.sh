#!/bin/bash

cd jena
java -Xmx20g -jar jars/fuseki-leapfrog.jar --loc=db/leapfrog --timeout=300000 /jenaleapfrog &
cd ..

sleep 1m

echo warming up
python benchmark.py queries/warmup.txt http://localhost:3030/jenaleapfrog/sparql > /dev/null
echo "[done]"
sleep 1m

for file in $1/*.txt
do
	queryName=$(basename $file)
	echo processing $queryName
	python benchmark.py ${1}/$queryName http://localhost:3030/jenaleapfrog/sparql > ${1}/output/${queryName%%.txt}/leapfrog
	echo "[done]"
done

kill $!
