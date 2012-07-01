name "database"
description "Database for hosting packages"
run_list(
  "recipe[mongodb::10gen_repo]",
  "recipe[mongodb]"
)
