# == Class: avidemux::repo
#
# This class exists to coordinate all repository related actions, functionality
# and logical units in a central place.
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
#   class { 'avidemux::repo': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * SYN Systems <mailto:puppet@dev.syn-systems.com>
#
class avidemux::repo {

  #### Repository management

  case $::operatingsystem {
    'Fedora': {
      # RPM Fusion
      # ATTENTION: No removal when "ensure => absent" because RPM Fusion may
      #            still be needed by other modules or programs.
      if $avidemux::ensure == 'present' {
        # install
        if !defined(Class['libyum::repo::rpmfusion']) {
          class { 'libyum::repo::rpmfusion': }
        # inform if there are conflicts
        } elsif $libyum::repo::rpmfusion::ensure != 'present' {
          fail("RPM Fusion is required for \"${module_name}\" but ensured absent.")
        }
        # manage relationships
        Class['libyum::repo::rpmfusion'] -> Class['avidemux::repo']
      }
    }

    default: { }
  }

}
