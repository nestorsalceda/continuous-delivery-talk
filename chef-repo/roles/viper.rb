name "viper"
description "Install a viper worker"
run_list(
  "recipe[python]",
  "recipe[supervisor]",
  "recipe[viper]"
)
