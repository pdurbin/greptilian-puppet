class server1 {

  $server1_packages = [
    'git',
    'bind-utils',
    'vim-enhanced',
    'screen',
    'rpm-build',
    'rubygems',
    'rpmdevtools',
    'createrepo',
    'httpd',
    'gitweb',
    'epel-release',
    'salt-master',
    'salt-minion',
  ]

  package { $server1_packages:
    ensure => installed,
  }

  #user { 'git':
  #  ensure     => 'present',
  #  managehome => true,
  #}
  #
  #file { '/home/git':
  #  ensure => 'directory',
  #  owner  => 'git',
  #  group  => 'root',
  #  mode   => '0700',
  #}

  file { '/var/lib/git':
    ensure => 'directory',
    owner  => 'pdurbin',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/gitweb.conf':
    source => 'puppet:///server1/etc/gitweb.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
  }

  file { '/etc/yum.repos.d/greptilian.repo':
    source => 'puppet:///server1/etc/yum.repos.d/greptilian.repo',
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
  }

  file { '/etc/httpd/conf.d/0greptilian.conf':
    source => 'puppet:///server1/etc/httpd/conf.d/0greptilian.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
  }

  file { '/etc/httpd/conf.d/welcome.conf':
    source => 'puppet:///server1/etc/httpd/conf.d/welcome.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
  }

  file { '/etc/httpd/conf.d/yum.greptilian.com.conf':
    source => 'puppet:///server1/etc/httpd/conf.d/yum.greptilian.com.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
  }

  file { '/etc/httpd/conf.d/git.greptilian.com.conf':
    source => 'puppet:///server1/etc/httpd/conf.d/git.greptilian.com.conf',
    owner  => 'root',
    group  => 'root',
    mode   => '0444',
  }

  file { '/usr/sbin/server1-puppet-apply.sh':
    source => 'puppet:///server1/usr/sbin/server1-puppet-apply.sh',
    owner  => 'root',
    group  => 'root',
    mode   => '0555',
  }

  # http://docs.puppetlabs.com/references/stable/metaparameter.html#notify
  file { '/etc/sysconfig/iptables':
    source => 'puppet:///server1/etc/sysconfig/iptables',
    notify => Service['iptables'],
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  service { 'iptables':
    ensure => running
  }

  service { 'httpd':
    ensure => running
  }

}
