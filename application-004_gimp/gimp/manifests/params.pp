# == Class: gimp::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * SYN Systems <mailto:puppet@dev.syn-systems.com>
#
class gimp::params {

  #### Default values for the parameters of the main module class, init.pp

  # ensure
  $ensure = 'present'

  # autoupgrade
  $autoupgrade = false



  #### Default values for the parameters of the plugin::lqr class,
  #### plugin/lqr.pp

  # ensure
  $ensure_plugin_lqr = 'present'

  # autoupgrade
  $autoupgrade_plugin_lqr = false



  #### Default values for the parameters of the plugin::resynthesizer class,
  #### plugin/resynthesizer.pp

  # ensure
  $ensure_plugin_resynthesizer = 'present'

  # autoupgrade
  $autoupgrade_plugin_resynthesizer = false



  #### Internal module values

  # packages
  case $::operatingsystem {
    'Fedora': {
      # main application
      $package = [ 'gimp', 'gimp-data-extras' ]
      # plugins
      $package_plugin_lqr           = [ 'gimp-lqr-plugin' ]
      $package_plugin_resynthesizer = [ 'gimp-resynthesizer' ]
    }
    default: {
      fail("\"${module_name}\" provides no package default value for \"${::operatingsystem}\"")
    }
  }

}
