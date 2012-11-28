# == Class: gimp::plugin::lqr
#
# This class is able to install or remove the
# {GIMP Liquid Rescale Plug-In}[http://liquidrescale.wikidot.com] on a node.
#
#
# === Parameters
#
# [*ensure*]
#   String. Controls if the managed resources shall be <tt>present</tt> or
#   <tt>absent</tt>. If set to <tt>absent</tt>:
#   * The managed software packages are being uninstalled.
#   * Any traces of the packages will be purged as good as possible. This may
#     include existing configuration files. The exact behavior is provider
#     dependent. Q.v.:
#     * Puppet type reference: {package, "purgeable"}[http://j.mp/xbxmNP]
#     * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   * System modifications (if any) will be reverted as good as possible
#     (e.g. removal of created users, services, changed log settings, ...).
#   * This is thus destructive and should be used with care.
#   Defaults to <tt>present</tt>.
#
# [*autoupgrade*]
#   Boolean. If set to <tt>true</tt>, any managed package gets upgraded
#   on each Puppet run when the package provider is able to find a newer
#   version than the present one. The exact behavior is provider dependent.
#   Q.v.:
#   * Puppet type reference: {package, "upgradeable"}[http://j.mp/xbxmNP]
#   * {Puppet's package provider source code}[http://j.mp/wtVCaL]
#   Defaults to <tt>false</tt>.
#
# The default values for the parameters are set in gimp::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
#
# === Examples
#
# * Installation:
#     class { 'gimp::plugin::lqr': }
#
# * Removal/decommissioning:
#     class { 'gimp::plugin::lqr':
#       ensure => 'absent',
#     }
#
#
# === Authors
#
# * SYN Systems <mailto:puppet@dev.syn-systems.com>
#
class gimp::plugin::lqr(
  $ensure      = $gimp::params::ensure_plugin_lqr,
  $autoupgrade = $gimp::params::autoupgrade_plugin_lqr
) inherits gimp::params {

  #### Validate parameters

  # ensure
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  # autoupgrade
  validate_bool($autoupgrade)



  #### Manage actions

  # package(s)
  class { 'gimp::plugin::lqr::package': }



  #### Manage relationships

  if !defined(Class['gimp']) {
    fail("Class \"${module_name}\" has to be evaluated before \"${module_name}::plugin::lqr\"")
  }

  if ($ensure == 'present') and ($gimp::ensure != 'present') {
    fail('Cannot ensure plugin presence if the main application is ensured absent.')
  }

  if $ensure == 'present' {
    # we need the main application before managing plugins
    Class['gimp']          -> Class['gimp::plugin::lqr']
    Class['gimp::package'] -> Class['gimp::plugin::lqr::package']

  } else {
    # there is currently no need for a specific removal order
  }

}
