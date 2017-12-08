# This class manages workspaces(WS) specific jenkins configurations

class workspaces::jenkins::params {
  $wrkspuser          = "wrkspuser"  #$::workspaces::params::wrkspuser     #lookup({"name" => "workspaces::jenkins::wrkspuser"})
  $wrksptoken         = $::wrkspuser_token #$::workspaces::params::wrksptoken    #lookup({"name" => "workspaces::jenkins::wrksptoken", "default_value" => $::wrkspuser_token}) # default to wrkspuser_token fact
  $dslconfig          = "/usr/local/home/jenkins/Instances/WS/dslconfig.groovy"
  $nodes              = undef # lookup({"name" => "workspaces::jenkins::nodes"})
  $adminusers         = undef # lookup({"name" => "workspaces::jenkins::adminusers"})
  $site_environment   = "savm"
  $confset            = "wij_configuration_set"
  $instance_home      = "/usr/local/home/jenkins/Instances/WS"
  $static_users       = undef #TODO empty list? default mapping?

  $plugins = [
    'antisamy-markup-formatter',
    'ant',
    'build-blocker-plugin',
    'build-timeout',
    'credentials',
    'email-ext',
    'external-monitor-job',
    'git',
    'git-client',
    'github',
    'gradle',
    'groovy',
    'job-dsl',
    'junit',
    'mailer',
    'matrix-auth',
    'matrix-project',
    'maven-plugin',
    'parameterized-trigger',
    'pipeline-stage-step',
    'pipeline-milestone-step',
    'pipeline-build-step',
    'pipeline-input-step',
    'pipeline-graph-analysis',
    'pipeline-rest-api',
    'pipeline-stage-view',
    'plain-credentials',
    'preSCMbuildstep',
    'resource-disposer',
    'role-strategy',
    'run-condition',
    'scm-api',
    'script-security',
    'ssh-credentials',
    'ssh-slaves',
    'structs',
    'subversion',
    'token-macro',
    'workflow-aggregator',
    'workflow-support',
    'ws-cleanup',
  ]

}