# ##############################################################################
#  Copyright (c) 2010-2019 Methodics, Inc.
#  All Rights Reserved.
#
#  The software is provided "as is", without warranty of any kind, express
#  or implied, including but not limited to the warranties of merchantability,
#  fitness for a particular purpose and non-infringement. In no event shall
#  the authors or copyright holders be liable for any claim, damages or
#  other liability, whether in an action of contract, tort or otherwise,
#  arising from, out of or in connection with the software or the use or
#  other dealings in the software.
# ##############################################################################

import logging
import os

import click
from piflow import IPV, cmd, pmq

log = logging.getLogger(__name__)


def expand_env(value):
    return os.path.expanduser(os.path.expandvars(value))


def filter_unique(seq):
    seen = set()
    return [x for x in seq if not (x in seen or seen.add(x))]


def filter_exists(seq):
    return [x for x in seq if os.path.exists(x)]


@cmd.command('env')
@click.option('-s', '--shell', type=click.Choice(['sh', 'csh']),
              default='sh', show_default=True, help='shell')
@click.option('-u', '--unique', is_flag=True,
              show_default=True, help='unique append/prepend')
@click.option('-e', '--exists', is_flag=True,
              show_default=True, help='exists append/prepend')
@click.pass_context
def cmd_env(ctx, shell, unique, exists):
    """ Gather environment variables.

    \b
    prepend:
      key+=value -> PATH=$PATH:$VALUE
    append:
      key=+value -> PATH=$VALUE:$PATH
    set if undefined:
      key?=value
    set:
      key=value
    """

    def echo(k, v):
        fmt = dict(sh='export {}={}', csh='setenv {} {}')
        click.echo(fmt[shell].format(k, v))

    def prepend(key, value):
        cur = os.environ.get(key)
        var = cur.split(':')
        var.insert(0, value)
        if unique:
            var = filter_unique(var)
        if exists:
            var = filter_exists(var)
        var = ':'.join(var)
        if cur != var:
            echo(key, var)

    def append(key, value):
        cur = os.environ.get(key)
        var = cur.split(':')
        var.append(value)
        if unique:
            var = reversed(filter_unique(reversed(var)))
        if exists:
            var = filter_exists(var)
        var = ':'.join(var)
        if cur != var:
            echo(key, var)

    def ifnot(key, value):
        if not os.environ.get(key):
            echo(key, value)

    def export(key, value):
        if os.environ.get(key) != value:
            echo(key, value)

    def mapper(line):
        commands = [
            ('+=', prepend), ('=+', append),
            ('?=', ifnot), ('=', export)
        ]
        for c, cmd in commands:
            if c in line:
                k, v = line.split(c)
                cmd(k, expand_env(v))
                return

    ipv = IPV.from_ipid(ctx.obj['ws_manifest']['top_ipv']['ipid'])
    for item in pmq(ipv, 'env'):
        os.environ['WS_PATH'] = item['ws_path']
        os.environ['IP_PATH'] = item['ip_path']
        mapper(item['value'])
