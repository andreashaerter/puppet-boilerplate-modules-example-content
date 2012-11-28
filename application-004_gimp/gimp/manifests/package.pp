# == Class: gimp::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'gimp::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * SYN Systems <mailto:puppet@dev.syn-systems.com>
#
class gimp::package {

  #### Package management

  # set params: in operation
  if $gimp::ensure == 'present' {

    $package_ensure = $gimp::autoupgrade ? {
      true  => 'latest',
      false => 'present',
    }

  # set params: removal
  } else {
    $package_ensure = 'purged'
  }

  # action
  package { $gimp::params::package:
    ensure => $package_ensure,
  }

}
