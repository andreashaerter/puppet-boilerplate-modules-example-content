# == Class: avidemux::params
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
class avidemux::params {

  #### Default values for the parameters of the main module class, init.pp

  # ensure
  $ensure = 'present'

  # autoupgrade
  $autoupgrade = false



  #### Internal module values

  # packages
  case $::operatingsystem {
    # Avidemux is open source software but some parts of it may use
    # patent-based technologies. These software patents may apply in your
    # country and therefore require proper licensing. It is your legal
    # responsibility to make sure that the software you are installing can be
    # legally used in your country and for your intended purpose. This is not
    # legal advice. Ask your lawyer if you need professional help.
    'Fedora': {
      # Avidemux is not in the default repositories because it may use
      # patent-based technologies (cf. Fedora Licensing Guidelines). We can use
      # RPM Fusion instead.
      #
      # From http://j.mp/L5xjba: "avidemux is a meta-package which installs the
      # graphical, command line and plugin packages. If you want a smaller
      # setup, you may selectively install one or more of the avidemux-*
      # subpackages."
      $package = [ 'avidemux' ]
    }
    default: {
      fail("\"${module_name}\" provides no package default value for \"${::operatingsystem}\"")
    }
  }

}
