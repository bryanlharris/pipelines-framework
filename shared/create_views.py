# Runs every .sql file in a folder, in name order. Each file holds one
# CREATE OR REPLACE VIEW, so running them again is safe. The files name
# no catalog (schema.view only); --catalog picks it, so every target
# runs the same files.
#
# A view whose table does not exist yet is skipped, not failed: a new
# table's view is deployed before the pipeline first builds the table.
# The next job run creates the view. Other errors still fail the task.
#
# Output, one line per file:
#   ✅ created   ⏭️ skipped (table not there yet)   ❌ failed
import argparse
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--catalog", required=True)
parser.add_argument("--folder", required=True)
args = parser.parse_args()

spark.sql(f"USE CATALOG `{args.catalog}`")  # noqa: F821

for sql_file in sorted(Path(args.folder).glob("*.sql")):
    try:
        spark.sql(sql_file.read_text())  # noqa: F821
        print(f"✅ {sql_file.name}")
    except Exception as e:
        if "TABLE_OR_VIEW_NOT_FOUND" not in str(e):
            print(f"❌ {sql_file.name}")
            raise
        print(f"⏭️ {sql_file.name}: its table does not exist yet. {str(e).splitlines()[0]}")
