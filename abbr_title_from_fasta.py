#! /usr/local/bin/python

import re
import sys

IN = open(sys.argv[1], 'r')
for line in IN:
    if line.startswith('>'):
        m=re.search(r'^>[^\-]+\-(.)(?:[^_]+)\_(...).+\.\.\.(\d)$', line)
	if m:
            if re.search(r'Methanococcus_maripaludis', line):
	        print line 
	    else:
	        print '>' + m.group(1) + m.group(2) + '-' + m.group(3)
    else:
        print line,


