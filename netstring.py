#! /usr/bin/env python
# -*- coding: utf-8 -*-

from twisted.protocols.basic import NetstringReceiver
from twisted.internet.stdio import StandardIO

from twisted.internet import reactor
import sys


nr = NetstringReceiver()
StandardIO(nr)

def f():
    for i in sys.argv[1:]:
        nr.sendString(i)
    reactor.callLater(1, reactor.stop)

reactor.callLater(0, f)
reactor.run()
