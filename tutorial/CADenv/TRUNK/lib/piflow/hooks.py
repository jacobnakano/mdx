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
from glob import glob

import click
from piflow import IPV, cmd, pmq, run_cmd

log = logging.getLogger(__name__)


@cmd.command('hooks')
@click.pass_context
def cmd_hooks(ctx):
    """ Run workspace hooks. """
    click.echo('starting workspace hooks')

    ipv = IPV.from_ipid(ctx.obj['ws_manifest']['top_ipv']['ipid'])
    for item in pmq(ipv, 'hook'):
        for script in glob(os.path.join(item['ws_path'], item['ip_path'], item['value'])):
            click.echo(run_cmd([script]))
