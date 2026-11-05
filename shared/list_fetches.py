# First task of job "<dataset> - fetch". Reads datasets/<dataset>/fetch.yml,
# checks each entry, and hands the list to the fetch_all loop as task value
# "fetches".
#
# Every entry is checked, so a typo fails here, before anything downloads.
import argparse
from pathlib import Path

import yaml

parser = argparse.ArgumentParser()
parser.add_argument("--fetch_file", required=True)
args = parser.parse_args()


def check(path, entry):
    """Fail on a bad url, inbox_file or gunzip."""
    url = str(entry.get("url", ""))
    inbox_file = str(entry.get("inbox_file", ""))
    gunzip = entry.get("gunzip", False)
    if not url.startswith("https://"):
        raise ValueError(f'{path}: "url" is required and must start with https://')
    if not inbox_file.startswith("/Volumes/") or "/raw/inbox/" not in inbox_file:
        raise ValueError(f'{path}: "inbox_file" must be in a raw inbox, e.g. /Volumes/edsm/raw/inbox/powerPlay.json')
    if not isinstance(gunzip, bool):
        raise ValueError(f'{path}: "gunzip" must be true or false')
    if gunzip and inbox_file.endswith(".gz"):
        raise ValueError(f'{path}: with "gunzip", inbox_file is the unzipped name, e.g. powerPlay.json')


fetches = []
path = Path(args.fetch_file)
for entry in yaml.safe_load(path.read_text()) or []:
    check(path, entry)
    fetches.append({"url": entry["url"], "inbox_file": entry["inbox_file"], "gunzip": entry.get("gunzip", False)})
    print(f"📋 {entry['url']}")

print(f"{len(fetches)} to fetch")
dbutils.jobs.taskValues.set("fetches", fetches)  # noqa: F821
