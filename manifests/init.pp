# Class: workspaces
# ===========================
#
# The workspaces class handles all of the setup of workspace components that
# aren't irods or jenkins.  These are mainly helper scripts in svn, their
# requirements, and configuration.
#
# Parameters
# ----------
#
#
# * `wrkspuser` 
#
# The workspaces jenkins user - is looked up from hiera 
#
# * `wrksptoken`
#
# The token used by the jenkins api for the workspaces user - is looked up from
# hiera, defaults to the wrkspuser_token fact
#
# * `checkout_location`
#
# The path to where the svn repository is checked out
#
# * `checkout_revision`
#
# The revision to be checked out, defaults to HEAD
#

class workspaces (

  $wrkspuser     = $::workspaces::params::wrkspuser, 
  $wrksptoken    = $::workspaces::params::wrksptoken,
  $wrkspurl      = $::workspaces::params::wrkspurl,

  $checkout_location = $::workspaces::params::checkout_location,
  $checkout_revision = $::workspaces::params::checkout_revision,
  
) inherits workspaces::params {

  # TODO put in packages.pp?
  # these packages are needed for irods helper scripts
  package { 'python-irodsclient':
    ensure   => installed,
    provider => 'pip',
  }
  package { 'python-jenkins':
    ensure => installed,
  }

  # generate template used by irods job runner (executeJobFile.py)
  file { '/var/lib/irods/jenkins.conf':
    ensure  => 'file',
    content => template('workspaces/jenkins.conf.erb'),
    require => Class['irods::provider'],
  }

  vcsrepo { $checkout_location:
    ensure        => present,
    provider      => svn,
    source        => 'https://cbilsvn.pmacs.upenn.edu/svn/apidb/EuPathDBIrods/trunk',
    revision      => $checkout_revision,
  }

  # create links to individual files in svn checkout
  $msi_bin = '/var/lib/irods/msiExecCmd_bin'
  $link_defaults = { ensure => 'link', require => Class[irods::provider] }
  $links = {
    "$msi_bin/eventGenerator.py"                         => { target => "$checkout_location/Scripts/remoteExec/eventGenerator.py" },
    "$msi_bin/executeJobFile.py"                         => { target => "$checkout_location/Scripts/remoteExec/executeJobFile.py" },
    "/etc/irods/ud.re"                                   => { target => "$checkout_location/Scripts/ud.re" },
  }

  create_resources(file, $links, $link_defaults)

}



