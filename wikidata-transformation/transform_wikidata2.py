SOURCE_FILE = 'wikidata-prefiltered.nt'
TARGET_FILE = 'wikidata-filtered.nt'
BIG_PROPERTIES_FILE = 'removed_properties.txt'

big_properties = set()
f = open(BIG_PROPERTIES_FILE, 'r', encoding='utf-8')
while True:
    line = f.readline()
    if not (line):
        break
    else:
        big_properties.add(line.strip())

f.close
f1 = open(SOURCE_FILE, 'r', encoding='utf-8')
f2 = open(TARGET_FILE, 'w', encoding='utf-8')
while True:
    line = f1.readline()
    if not(line):
        break
    else:
        p = line.split()[1]
        if p not in big_properties:
            f2.write(line)

f1.close()
f2.close()
