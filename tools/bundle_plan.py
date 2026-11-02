"""
Show what a bundle deploy would do, by real name.

bundle plan lists resource keys (schemas.edsm_bronze); this prints the name
each lands on (edsm.bronze), grouped by type, with the fields a change
would touch. Catalogs, pipelines and jobs hang from their workspace, schemas
from their catalog and volumes from their schema.
-v adds the bundle keys. Read only: it runs bundle validate and plan, never
deploy.

Usage: py tools/bundle_plan.py <target> [-v]      e.g. py tools/bundle_plan.py free
"""
import argparse
import json
import os
import shutil
import subprocess
import sys
from dataclasses import dataclass

# bundle plan's action names, shown as plainer words.
ACTIONS = {'skip': 'unchanged', 'update': 'change'}

# Order of actions in the summary line.
SUMMARY_ORDER = ['create', 'change', 'recreate', 'delete', 'unchanged']

# Schemas and volumes print in layer order: raw first, then the rest.
LAYERS = {'raw': 0, 'bronze': 1, 'silver': 2, 'gold': 3}

# Width of the action column ("unchanged" plus a space).
ACTION_WIDTH = 10


# Box lines and arrow on a console; plain ASCII when piped
if sys.stdout.isatty():
    MID, LAST, BAR, ARROW = '├──', '└──', '│  ', '→'
else:
    MID, LAST, BAR, ARROW = '|--', '`--', '|  ', '->'


# Action colors on a console, unless NO_COLOR is set
RED    = '\x1b[38;2;204;85;85m'     # CC5555 deletes
GREEN  = '\x1b[38;2;78;186;101m'    # 4EBA65 creates
YELLOW = '\x1b[38;2;255;193;7m'     # FFC107 changes
DIM    = '\x1b[2m'                  # unchanged
RESET  = '\x1b[0m'
CODES  = {
    'delete':    RED,
    'recreate':  RED,
    'create':    GREEN,
    'change':    YELLOW,
    'unchanged': DIM,
}
COLOR  = sys.stdout.isatty() and not os.environ.get('NO_COLOR')


@dataclass
class Row:
    """One resource in the tree."""
    name: str      # job, schema or volume name
    action: str    # create, change, delete, recreate or unchanged
    note: str      # prevent_destroy, when set
    key: str       # the bundle key, shown with -v
    fields: list   # "field: old -> new" lines printed under the row


def paint(action, text):
    """text in the action's color."""
    code = CODES.get(action)
    return f'{code}{text}{RESET}' if COLOR and code else text


def cli(*args):
    """Run a databricks bundle command and return its JSON output."""
    exe = shutil.which('databricks')
    if not exe:
        sys.exit('databricks CLI not found on PATH')
    run = subprocess.run([exe, 'bundle', *args, '-o', 'json'],
                         capture_output=True, text=True, encoding='utf-8')
    if run.returncode:
        sys.exit(run.stderr.strip() or run.stdout.strip())
    return json.loads(run.stdout)


def workspace(config):
    """The target's workspace, by profile name."""
    profile = config.get('workspace', {}).get('profile', '')
    return f'workspace {profile}'.strip()


def state(entry):
    """The resource as it will be (create, change) or as it is (delete, unchanged)."""
    new = entry.get('new_state', {}).get('value')
    if new is not None:
        return new
    return entry.get('remote_state', {})


def protected(config, kind, key):
    """prevent_destroy when deploy refuses to delete it."""
    resource = config.get('resources', {}).get(kind, {}).get(key, {})
    if resource.get('lifecycle', {}).get('prevent_destroy'):
        return 'prevent_destroy'
    return ''


def changes(entry, skip=()):
    """Fields a change would touch, skipping the ones plan marks unchanged
    and the ones in skip (already shown on the row)."""
    out = []
    for field, c in sorted(entry.get('changes', {}).items()):
        if c.get('action') == 'skip' or field in skip:
            continue
        old = c.get('old', c.get('remote'))
        new = c.get('new')
        out.append(f'{field}: {show(old)} {ARROW} {show(new)}')
    return out


def show(value):
    """A changed value, as JSON."""
    return json.dumps(value)


def layer_order(name):
    """Sort key for schema names: raw, bronze, silver, gold, then the rest."""
    return (LAYERS.get(name, len(LAYERS)), name)


def volume_order(path):
    """Sort key for /Volumes/<catalog>/<schema>: by the schema's layer."""
    schema = path.rsplit('/', 1)[-1]
    return (LAYERS.get(schema, len(LAYERS)), path)


def print_tree(groups, width, verbose):
    """groups: {heading: [Row, ...]}. Prints each heading, then its rows as
    branches. width is the name column, the same for every section so the
    actions line up."""
    for heading, rows in groups.items():
        print(f'  {heading}')
        for i, row in enumerate(rows):
            last = i == len(rows) - 1
            branch = LAST if last else MID
            flag = '!' if row.action in ('delete', 'recreate') else ' '
            action = paint(row.action, flag + row.action)
            padding = ' ' * (ACTION_WIDTH - len(row.action))
            key = f'   ({row.key})' if verbose else ''
            line = f'  {branch} {row.name:<{width}} {action}{padding} {row.note}{key}'
            print(line.rstrip())

            under = '   ' if last else BAR
            for field in row.fields:
                print(f'  {under}     {field}')


def main():
    parser = argparse.ArgumentParser(description='Show what a bundle deploy would do, by real name.')
    parser.add_argument('target', help='bundle target, e.g. dev')
    parser.add_argument('-v', '--verbose', '-verbose', action='store_true',
                        help='also show the bundle keys')
    args = parser.parse_args()
    target = args.target
    verbose = args.verbose

    config = cli('validate', '-t', target)
    entries = cli('plan', '-t', target)['plan']

    # Sort each resource into its section, and count the actions.
    counts = {}
    workspace_rows = {'catalogs': [], 'pipelines': [], 'jobs': []}
    catalogs = {}   # catalog name -> schema rows
    volumes = {}    # /Volumes/<catalog>/<schema> -> volume rows
    for full_key, entry in entries.items():
        _, kind, key = full_key.split('.', 2)   # resources.schemas.edsm_bronze
        action = ACTIONS.get(entry['action'], entry['action'])
        counts[action] = counts.get(action, 0) + 1
        s = state(entry)

        if kind in workspace_rows:
            row = Row(s.get('name'), action, protected(config, kind, key), key,
                      changes(entry))
            workspace_rows[kind].append(row)
        elif kind == 'schemas':
            row = Row(s.get('name'), action, protected(config, kind, key), key,
                      changes(entry))
            catalogs.setdefault(s.get('catalog_name'), []).append(row)
        else:
            row = Row(s.get('name'), action, protected(config, kind, key), key,
                      changes(entry))
            path = f"/Volumes/{s.get('catalog_name')}/{s.get('schema_name')}"
            volumes.setdefault(path, []).append(row)

    # Summary line: "Plan for dev: 2 create, 18 unchanged"
    order = SUMMARY_ORDER + sorted(a for a in counts if a not in SUMMARY_ORDER)
    parts = [paint(a, f'{counts[a]} {a}') for a in order if a in counts]
    print(f"Plan for {target}: {', '.join(parts) or 'nothing'}")

    # Each section is {heading: rows}, headings and rows in print order.
    def by_workspace(kind):
        rows = workspace_rows[kind]
        return {workspace(config): sorted(rows, key=lambda r: r.name)} if rows else {}

    schema_section = {}
    for catalog in sorted(catalogs):
        schema_section[catalog] = sorted(catalogs[catalog], key=lambda r: layer_order(r.name))

    volume_section = {}
    for path in sorted(volumes, key=volume_order):
        volume_section[path] = sorted(volumes[path], key=lambda r: r.name)

    sections = {
        'Catalogs': by_workspace('catalogs'),
        'Schemas': schema_section,
        'Volumes': volume_section,
        'Pipelines': by_workspace('pipelines'),
        'Jobs': by_workspace('jobs'),
    }

    # The name column is as wide as the longest name in any section.
    all_rows = [row for section in sections.values()
                for rows in section.values() for row in rows]
    width = max((len(row.name) for row in all_rows), default=0)

    for title, groups in sections.items():
        if groups:
            print(f'\n{title}')
            print_tree(groups, width, verbose)


if __name__ == '__main__':
    main()
