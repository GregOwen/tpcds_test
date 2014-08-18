from sys import argv
from collections import defaultdict
from tempfile import NamedTemporaryFile

script, time_file = argv

query_times = defaultdict(list)

# Read input file
with open(time_file) as rf:
    for line in rf.readlines():
        query, time = line.rstrip().split('\t')
        query_times[query].append(time)

# Drop min and max times
for (query, times) in query_times.items():
    times.sort()
    print "%s\t%r" % (query, times[len(times)/2])
