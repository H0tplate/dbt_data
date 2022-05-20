# dbt for BigQuery Bootcamp

This project contains a [dbt](https://getdbt.com) project.

dbt is a tool that runs the Transform step of your ELT (Extract-Load-Transform) process. Essentially, you load data into your warehouse (Redshift) with FiveTran or other tools (the EL steps)
and then transform it with dbt.

dbt Concepts:
- Sources
    - These are references to data sources loaded by your EL process
    - Defined inn source.yml files (inside models/ subfolders)
- Data
    - These are CSV files that define a mostly static dataset
    - These files live in the data/ folder
    - These are loaded with the `dbt seed` command
- Models
    - These are the bread and butter of dbt
    - These reference sources and other models
    - You are meant to build models on top of models which means you can contain business logic of how data fits together in a single place so that if that piece of logic needs to change it only has to be changed in one place

## Prerequisites

### Create your profiles.yml
```yml
company: #this needs to match your profile in your project.yml
  target: dev
  outputs:
    dev:
      type: bigquery
      method: oauth
      project: big-time-data-project #bigquery project name
      dataset: dbt_rachel #this will be where your locally ran models will show up
      threads: 4
```
Get your credentials from (Who should they get credentials from?)
The default place to put this file is in `~/.dbt/profiles.yml`

Set the DBT_PROFILE_PATH env var
```sh
export DBT_PROFILE_PATH=~/.dbt
```

### Test ability to run dbt
Now you can run dbt locally
```sh
dbt --version
```
You can now run all the [dbt CLI commands](https://docs.getdbt.com/reference/dbt-commands)

Try a dbt run in the container
```sh
dbt run --models dim_date
```
This should successfully run and look similar to
```sh
root@3cc894b68e70:/usr/app# dbt run --models dim_date
Running with dbt=1.1.0
Found 3 models, 10 tests, 0 snapshots, 0 analyses, 487 macros, 0 operations, 1 seed file, 2 sources, 0 exposures, 0 metrics

13:54:06 | Concurrency: 4 threads (target='dev')
13:54:06 |
13:54:06 | 1 of 1 START table view dbt_rachel.dim_date............................. [RUN]
13:54:10 | 1 of 1 OK created table view dbt_rachel.dim_date........................ [SELECT in 3.68s]
13:54:11 |
13:54:11 | Finished running 1 table view in 13.18s.

Completed successfully

Done. PASS=1 WARN=0 ERROR=0 SKIP=0 TOTAL=1
```


## dbt
### Running dbt Locally
#### Examples of common commands
##### dbt run
This runs all models in the project
```sh
root@8c08b24fb481:/usr/app# dbt run
Running with dbt=0.18.0
Found 130 models, 17 tests, 0 snapshots, 0 analyses, 447 macros, 0 operations, 8 seed files, 110 sources

15:51:40 | Concurrency: 4 threads (target='dev')
15:51:40 | 
15:51:40 | 1 of 130 START table model dev_sales_customers.account_facts_start_date [RUN]
15:51:40 | 2 of 130 START table model dev_app_usage.opportunity_line_item_mrr_by_date.......... [RUN]
15:51:40 | 3 of 130 START table model dev_app_usage.account_util_dates.............. [RUN]
15:51:40 | 4 of 130 START table model dev_utils.dates........................... [RUN]
```
##### dbt run --models [MODEL NAME]
This runs a specific model in the project
```sh
root@8c08b24fb481:/usr/app# dbt run --models opportunity_line_item_mrr_by_date
Running with dbt=0.18.0
Found 130 models, 17 tests, 0 snapshots, 0 analyses, 447 macros, 0 operations, 8 seed files, 110 sources

15:53:55 | Concurrency: 4 threads (target='dev')
15:53:55 | 
15:53:55 | 1 of 1 START table model dev_app_usage.opportunity_line_item_mrr_by_date............ [RUN]
15:54:02 | 1 of 1 OK created table model dev_app_usage.opportunity_line_item_mrr_by_date....... [SELECT in 7.01s]
15:54:02 | 
15:54:02 | Finished running 1 table model in 11.21s.

Completed successfully
```
##### dbt run --models tag:[TAG]
This runs models with a specific tag
```sh
root@8c08b24fb481:/usr/app# dbt run --models tag:daily
Running with dbt=0.18.0
Found 130 models, 17 tests, 0 snapshots, 0 analyses, 447 macros, 0 operations, 8 seed files, 110 sources

15:55:48 | Concurrency: 4 threads (target='dev')
15:55:48 | 
15:55:48 | 1 of 41 START table model dev_finance.opportunity_line_item_mrr_by_date [RUN]
15:55:48 | 2 of 41 START table model dev_finance.account_util_dates............. [RUN]
```
##### dbt seed
This runs all seeds
```sh
root@8c08b24fb481:/usr/app# dbt seed
Running with dbt=0.18.0
Found 130 models, 17 tests, 0 snapshots, 0 analyses, 447 macros, 0 operations, 8 seed files, 110 sources

16:07:16 | Concurrency: 4 threads (target='dev')
16:07:16 | 
16:07:16 | 1 of 8 START seed file dev_targets.aggregate_quota................... [RUN]
16:07:16 | 2 of 8 START seed file dev_targets.cohort_quota...................... [RUN]
16:07:16 | 3 of 8 START seed file dev_targets.implementation_target............. [RUN]
```
##### dbt seed --select [SEED NAME]
This runs a specific seed
```sh
root@8c08b24fb481:/usr/app# dbt seed --select aggregate_quota
Running with dbt=0.18.0
Found 130 models, 17 tests, 0 snapshots, 0 analyses, 447 macros, 0 operations, 8 seed files, 110 sources

16:08:03 | Concurrency: 4 threads (target='dev')
16:08:03 | 
16:08:03 | 1 of 1 START seed file dev_staging.aggregate_quota............... [RUN]
16:08:07 | 1 of 1 OK loaded seed file dev_staging.aggregate_quota........... [INSERT 997 in 4.50s]
16:08:08 | 
16:08:08 | Finished running 1 seed in 8.22s.
```
##### dbt compile
This generates executable SQL from source model, test, and analysis files
```sroot@8c08b24fb481:/usr/app# dbt compile
Running with dbt=0.18.0
Found 130 models, 17 tests, 0 snapshots, 0 analyses, 447 macros, 0 operations, 8 seed files, 110 sources

16:25:17 | Concurrency: 4 threads (target='dev')
16:25:17 | 
16:25:20 | Done.
root@8c08b24fb481:/usr/app#
```
##### dbt deps
This pulls the recent version of the dependencies in your packages.yml
```sh
root@8c08b24fb481:/usr/app# dbt deps
Running with dbt=0.18.0
Installing calogica/dbt_date@0.3.2
  Installed from version 0.3.2

Installing fishtown-analytics/dbt_utils@0.6.6
  Installed from version 0.6.6
```