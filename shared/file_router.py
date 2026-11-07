# Moves files from a dataset's inbox to its files volume, adding a time stamp.
#
#   /Volumes/<catalog>/raw/inbox/powerPlay.json
#   -> /Volumes/<catalog>/raw/files/powerPlay/powerPlay_20261102_120000.json
#
# A file belongs to a name if it is the name, or starts with the name and "_"
# (powerPlay_extra.json). Longest name wins. A folder moves the same way, whole,
# into files/<name>/<folder>/<stamp>/. Anything else goes to inbox/bad_files.
# Tells the next task how many it moved (task value "moved").
import argparse
from datetime import datetime
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--catalog", required=True)
# One value per table (a YAML list in resources.yml), or comma-separated.
parser.add_argument("--names", required=True, nargs="+", help="e.g. powerPlay systems, or powerPlay,systems")
args = parser.parse_args()

inbox = Path(f"/Volumes/{args.catalog}/raw/inbox")
files = Path(f"/Volumes/{args.catalog}/raw/files")
bad_files = inbox / "bad_files"
stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
names = sorted({n for arg in args.names for n in arg.split(",") if n}, key=len, reverse=True)

# Every name gets its folder, so the pipeline finds all its source paths.
bad_files.mkdir(exist_ok=True)
for name in names:
    (files / name).mkdir(exist_ok=True)


def match(stem):
    for name in names:
        if stem == name or stem.startswith(f"{name}_"):
            return name
    return None


good, bad = [], []
for item in sorted(inbox.iterdir()):
    if item == bad_files:
        continue
    stem, suffix = (item.name, "") if item.is_dir() else (item.stem, item.suffix)
    name = match(stem)
    if name is None:
        dest = bad_files / f"{stem}_{stamp}{suffix}"
        bad.append((item.name, dest))
    elif item.is_dir():
        dest = files / name / stem / stamp
        dest.parent.mkdir(exist_ok=True)
        good.append((item.name, dest))
    else:
        dest = files / name / f"{stem}_{stamp}{suffix}"
        good.append((item.name, dest))
    dbutils.fs.mv(str(item), str(dest), recurse=item.is_dir())  # noqa: F821

print(f"File router, {args.catalog}, {stamp}")
print(f"\n🟢 Moved to files: {len(good)}")
for src, dest in good:
    print(f"   {src} -> {dest}")
print(f"\n❌ Moved to bad_files: {len(bad)}")
for src, dest in bad:
    print(f"   {src} -> {dest}")

dbutils.jobs.taskValues.set("moved", len(good))  # noqa: F821
