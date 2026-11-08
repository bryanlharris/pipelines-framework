← [test_dev.md](test_dev.md) | none →

# Release Dev

Puts master on dev as a tag that never moves, e.g. **dev_v0.001**. The tag
names the commit dev runs.

1. Switch to master, and pull.
2. Check the tree is clean. A deploy uploads uncommitted edits too.
3. List the dev tags. Pick the next number for **YOUR_TAG**.
4. Tag master.
5. Push the tag.
6. Switch to the tag. Your files become that commit.
7. Check the plan. It shows only what the release changes.
8. Deploy.
9. Check the plan again. All show unchanged.
10. Switch back to master.
11. End.

```
git switch master
git pull
git status
git tag -l "dev_v*"
git tag YOUR_TAG
git push origin YOUR_TAG
git switch --detach YOUR_TAG
py tools/bundle_plan.py dev
databricks bundle deploy -t dev
py tools/bundle_plan.py dev
git switch master
```

---

← [test_dev.md](test_dev.md) | none →
