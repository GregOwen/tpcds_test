"""
 " clean_queries.py
 " Removes comments from tpcds queries
"""

from sys import argv
from os import listdir
from os.path import isfile, join
import re

script, QUERY_DIR, OUT_DIR = argv

filenames = [f for f in listdir(QUERY_DIR) if isfile(join(QUERY_DIR, f))]

def clean(line):
    start_c = r'/\*'
    end_c = r'\*/'
    line_c = r'--'
    if "exit;" in line:
        return ''
    if re.search(start_c, line) is not None:
        line = (line[:re.search(start_c, line).start()]
                  + line[re.search(end_c, line).end():])
    if re.search(line_c, line) is not None:
        line = line[:re.search(line_c, line).start()]
    return line

for name in filenames:
    in_path = join(QUERY_DIR, name)
    out_path = join(OUT_DIR, name)
    new_lines = []
    with open(in_path, 'r') as rf:
        new_lines = [clean(line) for line in rf.readlines()]
    with open(out_path, 'w') as wf:
        for line in new_lines:
            wf.write(line)
