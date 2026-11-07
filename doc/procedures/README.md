# Procedures

To write a new procedure, copy one like it.

## Procedures

- [setup.md](setup.md): set up the computer and CLI
- [build_one_table_dataset.md](build_one_table_dataset.md): teaches how to build a full table pipeline using sdp-meta techniques
- [build_many_table_dataset.md](build_many_table_dataset.md): builds a dataset with any number of tables, from the dataset template
- [dev.md](dev.md): set up the dev target, test it, then release to it

## Details

[setup.md](setup.md): This is a basic setup of your laptop so you can do things like grep and sed even if you're on Windows. It also sets up things like an edit alias so all users edit files with the same command. This way procedures can be more common between Apple and PC.

[build_one_table_dataset.md](build_one_table_dataset.md): This does one tiny step at a time and lets you see the results in Databricks as you go. This is more like a bootcamp for sdp-meta. It's not efficient but if you follow this you should get the idea of how everything works.

[build_many_table_dataset.md](build_many_table_dataset.md): You copy one folder and fill in the blanks. This procedure is much easier once you do the build_one_table_dataset procedure.

[dev.md](dev.md): This shows how the dev target works and sets it up. You'll see how each target names its own bucket, so all three targets use the same code. It also shows how to tag a release and deploy it to dev.
