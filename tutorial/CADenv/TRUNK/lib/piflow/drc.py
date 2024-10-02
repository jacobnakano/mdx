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
from piflow import cmd, find_ipv, pmq

from stream import cmd_stream_out

log = logging.getLogger(__name__)


def create_rundir(path):
    if os.path.exists(path):
        log.info('removing: %s', path)
    subprocess.check_output(['rm', '-rf', path])
    if not os.path.exists(path):
        log.info('creating: %s', path)
        subprocess.check_output(['mkdir', '-p', path])


def full_path(item):
    return os.path.join(item['ws_path'], item['ip_path'], item['value'])


@cmd.command('drc')
@click.argument('identifier')
@click.argument('library')
@click.argument('cell')
@click.argument('view', default="layout", required=False)
@click.pass_context
def cmd_drc(ctx, identifier, library, cell, view):
    """ Run DRC physical verification. """
    click.echo('starting drc flow')
    ipv = find_ipv(ctx.obj['ws_manifest'], identifier)

    # start stream out
    ctx.invoke(cmd_stream_out, identifier=identifier, library=library, cell=cell, view=view)

    # create output structure
    ws = ctx.obj['ws_path']
    ip = '{library}.{ip}'.format(**ipv['ipid'])
    rundir = os.path.join(ws, 'output', ip, 'drc')
    create_rundir(rundir)

    # retrieve list "drc" definitions
    items = pmq(ipv, 'drc')

    # start drc
    engine = [x['value'] for x in items if 'engine' in x['labels']][0]
    cmd = [engine, '-drc', '-rundir', rundir]

    # collect all flags
    for item in items:
        if 'flags' in item['labels']:
            cmd.extend(['-def', item['value']])

    # collect all waivers
    for item in items:
        if 'waivers' in item['labels']:
            cmd.extend(['-waiver', full_path(item)])

    # collect all rules
    for item in items:
        if 'rules' in item['labels']:
            cmd.extend(['-rule', full_path(item)])

    # start calibre
    log.info('starting: %s', ' '.join(cmd))
