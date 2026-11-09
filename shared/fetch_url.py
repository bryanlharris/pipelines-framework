# One iteration of job "<dataset> - fetch": downloads one URL into a dataset's
# inbox. The router (job "<dataset> - ingest") takes it from there, the same
# as a file sent by an upload script.
#
#   --fetch  one entry from a datasets/<dataset>/fetch.yml, as JSON
#            (list_fetches.py checked it). {year} in url becomes this year.
#
# The file goes to local disk first, then into the inbox in one copy, so the
# inbox trigger never sees half a file.
#
# Output:
#   ✅ fetched   ❌ failed
import argparse
import gzip
import json
import shutil
import tempfile
from datetime import date
from pathlib import Path

import requests

parser = argparse.ArgumentParser()
parser.add_argument("--fetch", required=True)
args = parser.parse_args()

fetch = json.loads(args.fetch)
url = fetch["url"].replace("{year}", str(date.today().year))
inbox_file = Path(fetch["inbox_file"])
gunzip = fetch.get("gunzip", False)

with tempfile.TemporaryDirectory() as tmp:
    download = Path(tmp) / inbox_file.name
    try:
        # www.edsm.net answers 403 to the default requests User-Agent, so name the script.
        with requests.get(url, timeout=300, stream=True, headers={"User-Agent": "pipelines-framework-fetch/1.0"}) as response:
            response.raise_for_status()
            response.raw.decode_content = True
            body = gzip.GzipFile(fileobj=response.raw) if gunzip else response.raw
            with open(download, "wb") as out:
                shutil.copyfileobj(body, out, 1024 * 1024)
        shutil.copyfile(download, inbox_file)
    except Exception as e:
        print(f"❌ {url}")
        print(f"   {type(e).__name__}: {e}")
        raise

print(f"✅ {url}")
print(f"   → {inbox_file} ({inbox_file.stat().st_size:,} bytes)")
