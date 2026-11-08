# Procedures

To write a new procedure, copy one like it.

## Procedures

- [setup.md](setup.md): set up the computer and CLI
- [build_one_table_dataset.md](build_one_table_dataset.md): teaches how to build a full table pipeline using sdp-meta techniques
- [build_many_table_dataset.md](build_many_table_dataset.md): builds a dataset with any number of tables, from the dataset template
- [targets/](targets/README.md): set up a target: free, dev, staging or prod
- [add_rules.md](add_rules.md): add a data quality rule: warn, drop, or fail
- [remove_bad_file.md](remove_bad_file.md): skip a bad file, and load a fixed copy
- [admin.md](admin.md): small tasks, e.g. apply settings, refresh, full refresh
- [add_custom_code.md](add_custom_code.md): give one dataset its own Python, beyond what the YAML can do

## Details

[setup.md](setup.md): This is a basic setup of your laptop so you can do things like grep and sed even if you're on Windows. It also sets up things like an edit alias so all users edit files with the same command. This way procedures can be more common between Apple and PC.

[build_one_table_dataset.md](build_one_table_dataset.md): This does one tiny step at a time and lets you see the results in Databricks as you go. This is more like a bootcamp for sdp-meta. It's not efficient but if you follow this you should get the idea of how everything works.

[build_many_table_dataset.md](build_many_table_dataset.md): You copy one folder and fill in the blanks. This procedure is much easier once you do the build_one_table_dataset procedure.

[targets/](targets/README.md): One procedure per target. dev.md shows how the dev target works and sets it up. You'll see how each target names its own bucket, so all three targets use the same code. It also shows how to tag a release and deploy it to dev.

[remove_bad_file.md](remove_bad_file.md): This skips a bad file without deleting it, since nothing in raw/files is ever deleted. If the pipeline stopped on the file, you fix a copy and upload it. If its records already landed, a full refresh takes them out.

[admin.md](admin.md): Small tasks you run now and then, one section each: apply settings after a conf/ change, refresh, full refresh, unknown files, rule counts, errors, and the fetch schedule.

[add_custom_code.md](add_custom_code.md): Most datasets need only YAML. When one needs Python, it gets its own copy of the pipeline runner, and the rest stay on the shared one.

[add_rules.md](add_rules.md): Rules check every record. A warn rule counts odd records, a drop rule removes records you can't use, and a fail rule stops the pipeline on a broken file.
