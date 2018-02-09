#!/bin/bash

# Catch errors and undefined variables
set -euo pipefail

source "${UPLOADS_DIR}/env"

# Create configuration file
echo "=> Creating configuration file for Ghost..."
cat >"$CONF_FILE" <<EOF
{
    "url": "http://127.0.0.1",
    "server": {
        "host": "0.0.0.0",
        "port": 8080
    },
    "database": {
        "client": "mysql",
        "connection": {
            "host"     : "${DATABASE_HOST}",
            "user"     : "${DATABASE_USER}",
            "password" : "${DATABASE_PASSWORD}",
            "database" : "${DATABASE_NAME}"
        }
    },
    "auth": {
        "type": "password"
    },
    "paths": {
        "contentPath": "content/"
    },
    "logging": {
        "level": "info",
        "rotation": {
            "enabled": true
        },
        "transports": ["file", "stdout"]
    }
}
EOF
chown "$NON_ROOT_USER":"$NON_ROOT_USER" "$CONF_FILE"

# Init database    
cd "$APP_DIR"
echo "=> Initializing database..."
sudo -H -u "$NON_ROOT_USER" NODE_ENV=production ./node_modules/.bin/knex-migrator init

