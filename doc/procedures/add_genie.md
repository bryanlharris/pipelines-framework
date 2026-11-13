# Add a Genie Agent

Gives a dataset a Genie agent that answers questions about its silver and
gold tables in plain English. Each example ships one in its **genie.yml**.

## Prerequisites

1. The dataset's pipeline has run once, so its tables exist. Genie refuses
   an agent whose tables are missing, and the deploy fails.

## Steps

1. Copy the example's **genie.yml** into the dataset's folder. A dataset
   built from the template already has a commented **genie.yml**:
   uncomment it, and change its **CHANGE_ME** lines.
2. Set **warehouse_id** in the target, unless it's set: the SQL
   warehouse's id, from its page.
3. Check the plan. The agent shows create.
4. Deploy.
5. Open **YOUR_CATALOG - genie** in Genie, and ask one of its sample
   questions. It answers.
6. End.

```
cp examples/YOUR_DATASET/genie.yml datasets/YOUR_DATASET/
edit datasets/YOUR_DATASET/genie.yml
edit targets/YOUR_TARGET_FILE
py tools/bundle_plan.py YOUR_TARGET
databricks bundle deploy -t YOUR_TARGET
```
