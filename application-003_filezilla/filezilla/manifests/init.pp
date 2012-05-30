# == Class: filezilla
#
# This class is able to install or remove filezilla on a node.
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
# [*autoload_class*]
#   String or <tt>false</tt>. Name of a custom class to manage module
#   customization beyond the capabilities of the available module parameters
#   (e.g. by using class inheritance to overwrite resources). If defined, this
#   module will automatically execute <tt>class { $autoload_class: }</tt>.
#   Excessive usage of this feature is not recommended in order to keep node
#   definitions and class dependencies maintainable. Defaults to <tt>false</tt>.
#
# [*package*]
#   The default value to define which packages are managed by this module gets
#   set in filezilla::params. This parameter is able to overwrite the default.
#   Just specify your own package list as a {Puppet array}[http://j.mp/wzu7L3].
#   However, usage of this feature is <b>not recommended</b> in order to keep
#   the node definitions maintainable. It exists for <b>exceptional cases
#   only</b>.
#
# [*debug*]
#   Boolean switch to control the debugging functionality of this module. If set
#   to <tt>true</tt>:
#   * The main module class dumps all variables in its scope into the file
#     <tt>$settings::vardir/debug_[module_name]_vardump</tt>. This will be done
#     on every Puppet run. The file is located on the node
#     (<tt>{$settings::vardir}[http://j.mp/w1g0Bl]</tt> is
#     <tt>/var/lib/puppet</tt> by default).
#   * The variable dump file gives you the chance to spot if some variable is
#     not set as you want. Please note that variable names matching the pattern
#     <tt>/(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/</tt>
#     are excluded for security reasons.
#   If set to <tt>false</tt>:
#   * All debugging features are disabled.
#   * All possibly existing debug files this module created are being
#     removed/cleaned up (e.g. <tt>debug_[module_name]_vardump</tt>).
#   Defaults to <tt>false</tt>.
#
# The default values for the parameters are set in filezilla::params. Have
# a look at the corresponding <tt>params.pp</tt> manifest file if you need more
# technical information about them.
#
#
# === Examples
#
# * Installation:
#     class { 'filezilla': }
#
# * Removal/decommissioning:
#     class { 'filezilla':
#       ensure => 'absent',
#     }
#
# * Installation with alternative package list:
#     class { 'filezilla':
#       package => [ "foo", "bar-1.2.3" ],
#     }
#
# * Run installation with enabled debugging:
#     class { 'filezilla':
#       debug => true,
#     }
#
#
# === Authors
#
# * Andreas Haerter <mailto:ah@bitkollektiv.org>
#
class filezilla(
  $ensure         = $filezilla::params::ensure,
  $autoupgrade    = $filezilla::params::autoupgrade,
  $autoload_class = $filezilla::params::autoload_class,
  $package        = $filezilla::params::package,
  $debug          = $filezilla::params::debug
) inherits filezilla::params {

  #### Validate parameters

  # ensure
  if ! ($ensure in [ 'present', 'absent' ]) {
    fail("\"${ensure}\" is not a valid ensure parameter value")
  }

  # autoupgrade
  validate_bool($autoupgrade)

  # autoload_class
  if $autoload_class != false {
    if !is_string($autoload_class) or empty($autoload_class) {
      fail('"autoload_class" must be a valid class name or false')
    }
    if $autoload_class !~ /^[a-z](?:[a-z0-9_]*(?:\:\:)*[a-z0-9_]*){1,}[a-z0-9_]{1}$/ { # Cf. naming rules: http://j.mp/xuM3Rr and http://j.mp/wZ8quk
      warning("\"${autoload_class}\" violates class naming restrictions")
    }
  }

  # package list
  if !is_array($package) or empty($package) {
    fail('"package" parameter must be an array of package names, containing at least one element')
  }

  # debug
  validate_bool($debug)



  #### Manage actions

  # package(s)
  class { 'filezilla::package': }

  # automatically load/include custom class if needed
  if $autoload_class != false {
    class { $autoload_class: }
  }



  #### Debugging

  # dump variable names and values (idea from A. Franceschi, http://j.mp/wBJRjo)
  $debug_vardump_ensure = $debug ? {
    true  => 'present',
    false => 'absent',
  }
  file { "debug_${module_name}_vardump":
    ensure  => $debug_vardump_ensure,
    path    => "${settings::vardir}/debug_${module_name}_vardump",
    mode    => '0640',
    owner   => 'root',
    group   => 'root',
    # do not forget to update the class documentation (-> 'debug' parameter) if
    # you change the .reject regex pattern
    content => inline_template('<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime.*|path|timestamp|free|.*password.*|.*psk.*|.*key)/ }.sort.map { |k,v| "#{k}: #{v.inspect}"}.join("\n") + "\n" %>'),
  }

}

