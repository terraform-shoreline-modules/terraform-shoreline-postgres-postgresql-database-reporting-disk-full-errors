

#!/bin/bash



# Set the parameters

PGHOST=${HOST}

PGUSER=${USERNAME}

PGDATABASE=${DATABASE_NAME}



# Identify and delete any unnecessary data from the database

psql -h $PGHOST -U $PGUSER -d $PGDATABASE -c "DELETE FROM ${TABLE_NAME} WHERE ${CONDITION};"