name "base"
description "Base role applied to all nodes."

default_attributes(
  "authorization" => {
   "sudo" => {
    "users" => ["nimbus"],
    "groups" => ["admin","sudo"],
    "passwordless" => true
  }
 }
)
