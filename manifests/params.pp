class workspaces::params inherits workspaces::jenkins::params {

  $wrkspuser         = $::workspaces::jenkins::params::wrkspuser
  $wrksptoken        = $::workspaces::jenkins::params::wrksptoken

  $checkout_location = "/vagrant/scratch/svn_files"
  $checkout_revision = "HEAD"

}
