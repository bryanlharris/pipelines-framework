# Build a Many Table Dataset

Builds a dataset with any number of tables, from the whole dataset template.
Each table gets bronze, silver SCD2 and a current view. To learn how each
piece works, see [build_one_table_dataset.md](build_one_table_dataset.md).

## Prerequisites

1. [setup.md](setup.md): set up the computer and CLI
2. [dev.md](dev.md): set up dev, on enterprise only

## Steps

1. [add_dataset.md](build_many_table_dataset/add_dataset.md): add the dataset
2. [add_table.md](build_many_table_dataset/add_table.md): add a table; repeat for each table
3. End.

Later tables need only [add_table.md](build_many_table_dataset/add_table.md).
