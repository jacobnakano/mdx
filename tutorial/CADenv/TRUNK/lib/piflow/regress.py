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

import click
from piflow import cmd, find_ipv, pmq

log = logging.getLogger(__name__)


@cmd.command('regress')
@click.argument('identifier')
@click.pass_context
def cmd_regress(ctx, identifier):
    """ Run RTL regressions. """
    click.echo('starting RTL verification flow')

    ipv = find_ipv(ctx.obj['ws_manifest'], identifier)
    for item in pmq(ipv, 'rtl'):
        print(item)
