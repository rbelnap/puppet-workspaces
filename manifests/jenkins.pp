# Class: workspaces::jenkins
# ===========================
#
# This class manages workspaces(WS) specific jenkins configurations
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'workspaces':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#

class workspaces::jenkins ( 

  $dslconfig           = $::workspaces::jenkins::params::dslconfig,
  $wrkspuser           = $::workspaces::jenkins::params::wrkspuser,
  $nodes               = $::workspaces::jenkins::params::nodes,
  $adminusers          = $::workspaces::jenkins::params::adminusers,
  $site_environment    = $::workspaces::jenkins::params::site_environment,
  $confset             = $::workspaces::jenkins::params::confset,
  $instance_home       = $::workspaces::jenkins::params::instance_home,
  $static_users        = $::workspaces::jenkins::params::static_users,
  $plugins             = $::workspaces::jenkins::params::plugins,
  
) inherits workspaces::jenkins::params {

# TODO this is only applicable to savm
#  Class['::workspaces'] ->
#  Class['::workspaces::jenkins']

  $init_groovy = "${instance_home}/init.groovy.d"

  # this handles user and plugin setup
  file { "${init_groovy}/10_init.groovy":
    ensure  => 'file',
    content => template('workspaces/init.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  # this creates /usr/local/home/jenkins/jenkins_token.txt, which is linked
  # to /etc/facter/facts.d/ to provide this token as a fact to be used
  # elsewhere
  file { "${init_groovy}/12_token.groovy":
    ensure  => 'file',
    content => template('workspaces/token.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  # this sets up role based authentication
  file { "${init_groovy}/15_auth.groovy":
    ensure  => 'file',
    content => template('workspaces/auth.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  # this creates the irods node
  file { "${init_groovy}/20_irods_node.groovy":
    ensure  => 'file',
    content => template('workspaces/irods_node.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  # this executes the irodsWorkspacesJobs.groovy script
  file { "${init_groovy}/60_seed_job.groovy":
    ensure  => 'file',
    content => template('workspaces/seed_job.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  file { '/usr/local/home/jenkins/irodsWorkspacesJobs.groovy':
    ensure  => 'file',
    content => template('workspaces/irodsWorkspacesJobs.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }

  # template for all groovy script confs
  file { $dslconfig:
    ensure  => 'file',
    content => template('workspaces/dslconfig.groovy.erb'),
    notify  => Service['jenkins@WS'],
    owner   => 'jenkins',
    mode    => '0600'
  }


  # because this vm instance will dynamically generate the api token, the
  # 12_api_token.groovy script creates a file in jenkin's home with the
  # credentials.  we link it into facts.d here so that it can be used in puppet
  # elsewhere.  In a production scenario, we would likely set the token in
  # hiera directly.

  file { ['/etc/facter', '/etc/facter/facts.d']:
    ensure => directory,
  }

  file { '/etc/facter/facts.d/jenkins_token.txt':
    ensure => link,
    target => '/usr/local/home/jenkins/jenkins_token.txt',
    mode   => '700',
  }

}
