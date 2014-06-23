#!/usr/bin/env python

from sallyutils.reactor import installReactor
installReactor()

import os
import sys
from eventlet import spawn
from eventlet.twistedutil import join_reactor
assert join_reactor
from twisted.internet import reactor

from etYellowUtils.client.et_helper import getService

exit_code = 0
def main(plugin_name, cmd='fetch', *args):
    global exit_code
    result = ''
    try:
        monitor_sv = getService('monitor', 'PICKLE')
        result = monitor_sv.fetch_graph(plugin_name, cmd)
        print result
    except Exception, e:
        print 'EXCEPTION: ' + str(e)
        if cmd != 'autoconf':
            exit_code = 1
    finally:
        reactor.stop()


if __name__ == '__main__':
    plugin_name = os.path.basename(sys.argv[0])
    args = sys.argv[1:]
    spawn(main, plugin_name, *args)
    reactor.run()
    sys.exit(exit_code)
