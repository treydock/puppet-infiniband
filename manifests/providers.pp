# == Class: infiniband::providers
#
# Convenience class to call defined types provided
# by this module.
#
# See README.md for more details.
#
class infiniband::providers {
  create_resources('infiniband::interface', $infiniband::interfaces)
}
