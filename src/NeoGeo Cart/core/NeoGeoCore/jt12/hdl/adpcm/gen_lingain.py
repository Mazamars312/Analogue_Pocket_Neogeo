#!/usr/bin/python

import sys

db=0

for k in range(64):
    lin = 10**(db/20)*511
    sys.stdout.write("   mem[%03d] = 9'd%03d;" % (k, lin))
    if( k%4 == 3 ):
        sys.stdout.write("\n")
    # else:
    #     sys.stdout.write("  ")
    db = db - 0.75
