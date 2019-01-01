#!/bin/bash
if [ $# -lt 1 ]
then
	echo "Not enough arguments. Usage: bash run-benchmark <queries_folder>"
	exit 1
fi

if [ ! -d $1 ]
then
	echo "Queries folder doesn't exist."
	exit 1
fi

mkdir $1/output
if [ $? -ne 0 ]
then
	echo "Output folder already exists."
	exit 1
fi

for file in $1/*.txt
do
	queryName=$(basename $file)
	mkdir $1/output/${queryName%%.txt}
done

bash virtuoso-benchmark.sh $1
bash blazegraph-benchmark.sh $1
bash jena-benchmark.sh $1
bash leapfrog-benchmark.sh $1
