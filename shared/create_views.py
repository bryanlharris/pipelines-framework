# Runs every .sql file in a folder, in name order. Each file holds one
# CREATE OR REPLACE VIEW, so running them again is safe.
import argparse
from pathlib import Path

parser = argparse.ArgumentParser()
parser.add_argument("--folder", required=True)
args = parser.parse_args()

for sql_file in sorted(Path(args.folder).glob("*.sql")):
    print(f"Running {sql_file.name}")
    spark.sql(sql_file.read_text())  # noqa: F821
