#! /usr/bin/env python
# -*- coding: utf-8 -*-

import zlib, sys

l = len(sys.argv)

if l == 1:
    src = sys.stdin
elif l == 2:
    src = open(sys.argv[1], "r")
else:
    usage = "Usage: %s <file to deflate>\n\tcat <file to deflate> | %s\n" % (sys.argv[0], sys.argv[0])
    sys.stderr.write(usage)
    exit(1)

print src.read().decode("zlib")
