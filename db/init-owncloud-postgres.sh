#!/bin/bash

USERNAME="<set-username>"
PASSWORD="<set-password>"
DB="<set-db-name>"

echo "******CREATING DOCKER DATABASE******"
gosu postgres postgres --single <<- EOSQL
CREATE USER $USERNAME WITH PASSWORD '$PASSORD';
CREATE DATABASE $DB TEMPLATE template0 ENCODING 'UNICODE';
ALTER DATABASE $DB OWNER TO $USERNAME;
GRANT ALL PRIVILEGES ON DATABASE $DB TO $USERNAME;
EOSQL
echo "******DOCKER DATABASE CREATED******"
echo "********FIXING PERMISSIONS*********"
cat > /var/lib/postgresql/data/pg_hba.conf <<EOS
# Generated by fix-acl.sh
# TYPE  DATABASE        USER            ADDRESS                 METHOD
# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 trust

# Allow anyone to connect remotely so long as they have a valid username and 
# password.
host all all 0.0.0.0/0 md5
EOS
