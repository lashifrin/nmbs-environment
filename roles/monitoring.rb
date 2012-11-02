name "monitoring"
description "Monitoring server"
run_list(
  "recipe[nagios::server]",
  "recipe[postfix::server]"
)

default_attributes(
  "nagios" => {
    "server_auth_method" => "htauth"
  },
  "ntp" => {
     "is_server" => true
  }
)
