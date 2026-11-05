# Runs every .sql file in a folder, in name order. Each file holds one
# CREATE OR REPLACE VIEW, so running them again is safe.
#
# A view whose table does not exist yet is skipped, not failed: a new
# table's view is deployed before the pipeline first builds the table.
# The next job run creates the view. Other errors still fail the task.
import argparse
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--folder", required=True)
args = parser.parse_args()

for sql_file in sorted(Path(args.folder).glob("*.sql")):
    print(f"Running {sql_file.name}")
    try:
        spark.sql(sql_file.read_text())  # noqa: F821
    except Exception as e:
        if "TABLE_OR_VIEW_NOT_FOUND" not in str(e):
            raise
        print(f"  Skipped: its table does not exist yet. {str(e).splitlines()[0]}")
