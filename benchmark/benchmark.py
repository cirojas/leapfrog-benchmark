from SPARQLWrapper import SPARQLWrapper, JSON
import time
import traceback
import sys

sparql = SPARQLWrapper(sys.argv[2])
sparql.setTimeout(300)
sparql.setReturnFormat(JSON)

queries_file = open(sys.argv[1], "r")

queries = []
for line in queries_file:
    queries.append(line.strip())

query_number = 0
for query in queries:
    count = 0
    start_time = time.time()
    try:
        sparql.setQuery(query)
        results = sparql.query()

        end_time = time.time()
        elapsed_time = int((end_time - start_time)*1000000000)

        json_results = results.convert()
        for result in json_results["results"]["bindings"]:
            count += 1

        print("{0};{1};{2}".format(query_number, count, elapsed_time))
    except Exception as e:
        print("{0};{1};timeout".format(query_number, count))
        traceback.print_exc()
    query_number += 1
