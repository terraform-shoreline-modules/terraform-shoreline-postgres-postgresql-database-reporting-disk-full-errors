
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# PostgreSQL database reporting disk full errors.
---

This incident type refers to a problem with a PostgreSQL database where it is reporting disk full errors. This means that the database has reached its full capacity and cannot store any more data. This can cause issues with the performance of the database and may result in data loss if not addressed promptly.

### Parameters
```shell
export PATH_TO_POSTGRESQL_DATA_DIRECTORY="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export TABLE_NAME="PLACEHOLDER"

export BACKUP_DIRECTORY="PLACEHOLDER"

export HOST="PLACEHOLDER"

export USERNAME="PLACEHOLDER"

export CONDITION="PLACEHOLDER"
```

## Debug

### 1. Check the disk usage of the PostgreSQL data directory
```shell
df -h ${PATH_TO_POSTGRESQL_DATA_DIRECTORY}
```

### 2. Check the disk usage of the entire system to see if any other partitions are full
```shell
df -h
```

### 3. Check the size and usage of individual tables in the database
```shell
psql -d ${DATABASE_NAME} -c "SELECT pg_size_pretty(pg_total_relation_size('${TABLE_NAME}')) AS total_size;"
```

### 4. Check the size and usage of individual indexes in the database
```shell
psql -d ${DATABASE_NAME} -c "SELECT pg_size_pretty(pg_indexes_size('${TABLE_NAME}')) AS index_size;"
```

### 5. Check for any large and unnecessary files in the PostgreSQL data directory
```shell
find ${PATH_TO_POSTGRESQL_DATA_DIRECTORY} -type f -size +10M -exec ls -lh {} \;
```

### The disk where the PostgreSQL database is stored may have run out of storage space due to large database files or logs.
```shell
bash

#!/bin/bash



# check size of the PostgreSQL database files

du -hs ${PATH_TO_POSTGRESQL_DATA_DIRECTORY}



# check for any large backup files taking up space

find ${BACKUP_DIRECTORY} -type f -size +1G -exec ls -lh {} \;



# check for any other applications or processes consuming disk space

sudo lsof +L1 | awk '{print $1, $3, $4, $7}' | sort -h -k4


```

## Repair

### Identify and delete any unnecessary or unused data from the PostgreSQL database to free up disk space.
```shell


#!/bin/bash



# Set the parameters

PGHOST=${HOST}

PGUSER=${USERNAME}

PGDATABASE=${DATABASE_NAME}



# Identify and delete any unnecessary data from the database

psql -h $PGHOST -U $PGUSER -d $PGDATABASE -c "DELETE FROM ${TABLE_NAME} WHERE ${CONDITION};"


```