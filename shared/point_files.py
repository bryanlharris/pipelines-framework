# Second task of job "<dataset> - apply settings", after stage_conf.
# Points every source path in the staged onboarding.yml at --files_catalog's
# raw.files. On dev and prod that's the dataset's own catalog, so nothing
# really changes. Staging sets files_prefix to "", so it reads prod's
# raw.files and keeps its own empty.
import argparse
import re
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--onboarding_file", required=True)
parser.add_argument("--files_catalog", required=True)
args = parser.parse_args()

path = Path(args.onboarding_file)
files = f"/Volumes/{args.files_catalog}/raw/files/"
text, n = re.subn(r'[^"\s]*/\.\./\.\./\.\./raw/files/', files, path.read_text(encoding="utf-8"))
if n == 0:
    raise ValueError(f"{path}: no source path ends in ../../../raw/files/")
path.write_text(text, encoding="utf-8")
print(f"📂 {n} source paths read {files}")
