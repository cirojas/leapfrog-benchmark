# Code
The code for our leapfrog implementation for Apache Jena is available [here](https://github.com/cirojas/jena-leapfrog).


# Dataset
The dataset used was a reduced version of the Wikidata truthy dump from November 15, 2018. The original dump and its reduced version are available at [zenodo](https://zenodo.org/record/4035223).

# Repeating the experiments

### Prerequisites
- any x64 linux distribution with glib support
- java 8
- python (both 2 or 3 works)
- [bzip2](http://www.bzip.org/)
    - On a debian-based distro: `sudo apt install bzip2`
- [pip](https://pip.pypa.io/en/stable/installing/)
- [SPARQLWrapper](https://pypi.org/project/SPARQLWrapper/)

    Some of the following steps can take hours to complete, so we recommend using [tmux](https://github.com/tmux/tmux) to execute them.

### Getting the repo and the dataset
- Clone this repository.
    - `git clone git@github.com:cirojas/leapfrog-benchmark.git` if you use ssh keys

    or
    - `git clone https://github.com/cirojas/leapfrog-benchmark.git` if you don't.
- Download the [dataset used](https://zenodo.org/record/4035223/files/wikidata-wcg-filtered.nt.bz2?download=1) and move it to the `benchmark` folder
- Extract it `bzip2 -d wikidata-wcg-filtered.nt.bz2`
- Or you can [construct the dataset from the truthy wikidata dump](#building-the-dataset)

### Create the database for Jena and leapfrog
- Download the files apache-jena-3.9.0.tar.gz from [Apache Jena downloads page](https://jena.apache.org/download/index.cgi) or [here](https://drive.google.com/file/d/1cGPu18IrHPnWRUD0SB4QxrW5Avq5p4td/view?usp=sharing) and move it into `jena` folder
- Change directory into `jena` folder
- Extract it `tar -xf apache-jena-3.9.0.tar.gz`
- Create the database for jena `apache-jena-3.9.0/bin/tdbloader2 --loc=db/jena ../wikidata-wcg-filtered.nt`
- Edit the file `apache-jena-3.9.0/bin/tdbloader2index` with any text editor. After the line 389
    ```
    generate_index "$K3 $K1 $K2" "$DATA_TRIPLES" OSP
    ```
    add the following lines:

    ```
    generate_index "$K1 $K3 $K2" "$DATA_TRIPLES" SOP
    generate_index "$K2 $K1 $K3" "$DATA_TRIPLES" PSO
    generate_index "$K3 $K2 $K1" "$DATA_TRIPLES" OPS
    ```
    then save and exit.

- Create the database for the leapfrog implementation `apache-jena-3.9.0/bin/tdbloader2 --loc=db/leapfrog ../wikidata-wcg-filtered.nt`

### Create the database for Blazegraph
- Download Blazegraph jar from its [sourceforge page](https://sourceforge.net/projects/bigdata/files/bigdata/2.1.4/blazegraph.jar/download) or from [here](https://drive.google.com/file/d/1WyKccFoS397IBZdtDEbJ3NVaS3lDNjqd/view?usp=sharing) and move it into `blazegraph` folder
- Change directory into `blazegraph` folder
- `java -Xmx20g -cp blazegraph.jar com.bigdata.rdf.store.DataLoader load.properties ../wikidata-wcg-filtered.nt`

### Create the database for Virtuoso Opensource
- Download the file from Virtuoso Open Source Edition v7.2.5.1 from its [github releases page](https://github.com/openlink/virtuoso-opensource/releases) or from [here](https://drive.google.com/file/d/1HydvSChRzvUsWQOSwRL6JE2wLwLkq_ke/view?usp=sharing) and move it into `virtuoso` folder
- Change directory into `virtuoso` folder
- Extract it `tar -xf virtuoso-opensource.x86_64-generic_glibc25-linux-gnu.tar.gz`
- Init the server `virtuoso-opensource/bin/virtuoso-t -c virtuoso.ini`
- The server can take some time to start, wait a minute and start the interactive sql: `virtuoso-opensource/bin/isql localhost:1111` and enter the following commands:
    - `ld_dir('..', '*.nt', 'http://wikidata.org');`
    - `rdf_loader_run();`
    - `exit();`
- Shut down the server `virtuoso-opensource/bin/isql localhost:1111 -K`

### Run the benchmark
- Change directory into `benchmark` folder
- `bash run-benchmark.sh queries/bgps`
- `bash run-benchmark.sh queries/optionals`

    Now the results are available in the folders `queries/bgps/output` and `queries/optionals/output`

    For each query pattern you will find a folder containing four files, one for each database. Each line of a file contains three values separated by a semicolon: `queryNumber;numberOfResutls;executionTimeInNanoseconds`

# Building the dataset
- Download the Wikidata truthy dump `wikidata-wcg.nt.bz2` from [here](https://zenodo.org/record/4035223/files/wikidata-wcg.nt.bz2?download=1).
- Extract it `bzip2 -d wikidata-wcg.nt.bz2`.
- Move it to `wikidata-filter` folder and change directory to that folder.
- Execute `python remove_labels_and_descriptions.py` to remove labels and descriptions from wikidata, along with strings having other language than english.
- Execute `python remove_properties.py` to remove all properies listed in `removed_properties.txt` in our case we removed all properties that appeared more than 1.000.000 times or less than 1.000 times.

# Getting random queries for the benchmark
For each query pattern we created a java program that will find 50 random sets of properties with at least 1 result.
The jars are in the `find-queries` folder.
To find a query, you need to execute `java -jar find_XYZ.jar [jena-database-location] properties_wikidata.txt`, where `properties_wikidata.txt` is a file with the properties that can be chosen.

# Results
You can find our results in [our repository](https://github.com/cirojas/leapfrog-benchmark/tree/gh-pages/results)
