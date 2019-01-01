#!/bin/bash

cd blazegraph
java -Xmx20g -Djetty.overrideWebXml=override.xml -Dbigdata.propertyFile=load.properties -jar blazegraph.jar &
cd ..

sleep 1m

echo warming up
python benchmark.py queries/warmup.txt http://localhost:9999/blazegraph/sparql > /dev/null
echo "[done]"
sleep 1m

for file in $1/*.txt
do
	queryName=$(basename $file)
	echo processing $queryName
	python benchmark.py $1/$queryName http://localhost:9999/blazegraph/sparql > $1/output/${queryName%%.txt}/blazegraph
	echo "[done]"
done

kill $!
