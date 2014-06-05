# == Class: infiniband::install
#
class infiniband::install {
  ensure_packages($infiniband::support_packages)
}
