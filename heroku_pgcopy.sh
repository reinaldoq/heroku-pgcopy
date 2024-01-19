#!/bin/bash

# Set your app name
APP_NAME="product-pipe-reinaldo-q-0q2ezt"

# Set the plan for the new database
NEW_DATABASE_PLAN="mini"

# Set the name for the new and old databases
OLD_DATABASE_NAME="postgresql-curly-58731"

# Step 1: Provision a new database
heroku addons:create heroku-postgresql:$NEW_DATABASE_PLAN --app $APP_NAME

# Wait for the new database to be ready
heroku pg:wait -a $APP_NAME

# Step 2: Enter maintenance mode
heroku maintenance:on -a $APP_NAME

# Step 3: Transfer data to the new database
heroku pg:copy DATABASE_URL $NEW_DATABASE_NAME --app $APP_NAME

# Confirm the transfer
heroku pg:copy DATABASE_URL $NEW_DATABASE_NAME --confirm $APP_NAME

# Step 4: Promote the new database
heroku pg:promote $NEW_DATABASE_NAME --app $APP_NAME

# Step 5: Exit maintenance mode
heroku maintenance:off --app $APP_NAME

# Step 6: Deprovision the old primary database
heroku addons:destroy $OLD_DATABASE_NAME --app $APP_NAME
