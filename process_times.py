from sys import argv
from collections import defaultdict
from tempfile import NamedTemporaryFile

script, time_file = argv

query_times = defaultdict(list)

query_classes = {
    "Deep Analytics": ["q34", "q46", "q59", "q65", "q79", "ss_max"],
    "Interactive": ["q19", "q42", "q52", "q55", "q63", "q68", "q73", "q98"],
    "Reporting": ["q27", "q3", "q43", "q53", "q7", "q89"]
}

class_means = {}

def geo_mean(nums):
    """ https://blog.dlasley.net/2013/08/geometric-mean-in-python/ """
    return (reduce(lambda x, y: x*y, nums))**(1.0/len(nums))


with open(time_file) as rf:
    for line in rf.readlines():
        query, time = line.rstrip().split('\t')
        query_times[query].append(time)

# Drop min and max times
for (query, times) in query_times.items():
    times.sort()
    query_times[query] = times[1:-1]

# Aggregate by class
for (q_class, queries) in query_classes.items():
    files = [query + ".sql" for query in queries]
    class_times = [float(t) for fil in files for t in query_times[fil]]
    class_mean = geo_mean(class_times)
    class_means[q_class] = class_mean

# Write to output file
with open(NamedTemporaryFile(delete=False), 'w') as wf:
    for (q_class, time) in class_means:
        wf.write("%s\t%f\n" % (q_class, time))
    print "Wrote output to %s" % wf.name
