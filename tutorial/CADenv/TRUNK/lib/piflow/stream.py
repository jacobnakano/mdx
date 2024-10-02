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
import subprocess

import click
from click import ClickException
from piflow import cmd, find_ipv, pmq

log = logging.getLogger(__name__)


@cmd.group('stream')
def cmd_stream():
    """ Stream in/out commands. """


@cmd_stream.command('in')
@click.argument('identifier')
@click.argument('library')
@click.argument('cell')
@click.argument('view', default="layout", required=False)
def cmd_stream_in(ctx, identifier, library, cell, view):
    """ Cadence Stream In Flow. """
    raise ClickException('not implemented yet')


@cmd_stream.command('out')
@click.argument('identifier')
@click.argument('library')
@click.argument('cell')
@click.argument('view', default="layout", required=False)
@click.option('--compress', is_flag=True, default=False, help='compress result')
@click.pass_context
def cmd_stream_out(ctx, identifier, library, cell, view, compress):
    """ Cadence Stream Out Flow. """
    click.echo('Starting Stream Out')

    # find stream flags defined in IP's
    ipv = find_ipv(ctx.obj['ws_manifest'], identifier)
    for item in pmq(ipv, 'stream'):
        print(item)

    # create output structure
    ws = ctx.obj['ws_path']
    ip = '{library}.{ip}'.format(**ipv['ipid'])
    rundir = os.path.join(ws, 'output', ip, 'gds')
    if os.path.exists(rundir):
        log.info('removing: %s', rundir)
    subprocess.check_output(['rm', '-rf', rundir])
    if not os.path.exists(rundir):
        log.info('creating: %s', rundir)
        subprocess.check_output(['mkdir', '-p', rundir])

    # targets
    gds_file = os.path.join(rundir, 'strmout.gds')
    log_file = os.path.join(rundir, 'strmout.log')
    sum_file = os.path.join(rundir, 'strmout.sum')

    # run cadence streamout command
    cmd = ['strmout']
    cmd.extend(['-64'])
    cmd.extend(['-library', library])
    cmd.extend(['-topCell', cell])
    cmd.extend(['-view', view])
    cmd.extend(['-runDir', rundir])
    cmd.extend(['-logFile', log_file])
    cmd.extend(['-summaryFile', sum_file])
    cmd.extend(['-strmFile', gds_file])
    log.info('starting: %s', ' '.join(cmd))
    #subprocess.check_output(cmd)
    #if not os.path.exists(gds_file):
    #    raise ClickException('failed to create: {}'.format(gds_file))

    # and optionally compression
    if compress:
        log.info('compressing: %s', gds_file)
        subprocess.check_output(['gzip', '--best', gds_file])
