#!/bin/sh

# Set up auth config
tee /usr/local/lib/python3.11/site-packages/mlflow/server/auth/basic_auth.ini > /dev/null << EOF
[mlflow]
default_permission = READ
database_uri = $MLFLOW_AUTH_DATABASE_URI
admin_username = $MLFLOW_AUTH_ADMIN_USERNAME
admin_password = $MLFLOW_AUTH_ADMIN_PASSWORD
authorization_function = mlflow.server.auth:authenticate_request_basic_auth
EOF

# Start mlflow
mlflow server "$@"
