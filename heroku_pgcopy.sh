# Set your app name
set -e
set -x

APP_NAME=""

# Set the plan for the new database
NEW_DATABASE_PLAN="basic"

# Set the name for the new and old databases
OLD_DATABASE_NAME=""

# Step 1: Provision a new database
NEW_DATABASE_NAME="$(heroku addons:create heroku-postgresql:$NEW_DATABASE_PLAN --app $APP_NAME | grep -E 'Created postgresql-[a-z]+-[0-9]+ as HEROKU_POSTGRESQL_[A-Z]+_URL' | awk '{print $2'})"

# Wait for the new database to be ready
heroku pg:wait -a $APP_NAME

# Step 2: Enter maintenance mode
heroku maintenance:on -a $APP_NAME

read -p "Press any when heroku database is ready... " -n1 -s

# Step 3: Transfer data to the new database
heroku pg:copy DATABASE_URL $NEW_DATABASE_NAME --app $APP_NAME --confirm $APP_NAME

# Step 4: Promote the new database
#heroku pg:promote $NEW_DATABASE_NAME --app $APP_NAME

# Step 5: Exit maintenance mode
heroku maintenance:off --app $APP_NAME