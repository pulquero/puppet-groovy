# == Class: groovy
#
# Supported operating systems are:
#   - Ubuntu Linux
#   - Fedora Linux
#   - Debian Linux
#
# === Authors
#
# Spencer Herzberg <spencer.herzberg@gmail.com>
#
class groovy (
  $version  = 'UNSET',
  $base_url = 'UNSET',
  $url      = 'UNSET',
  $target   = 'UNSET',
  $timeout  = 360,
) {

  $version_real = $version ? {
    'UNSET' => '2.1.4',
    default => $version,
  }

  $base_url_real = $base_url ? {
    'UNSET' => "http://dist.groovy.codehaus.org/distributions",
    default => $base_url,
  }

  $url_real = $url ? {
    'UNSET' => "${base_url_real}/groovy-binary-${version_real}.zip",
    default => $url,
  }

  $target_real = $target ? {
    'UNSET' => "/opt/groovy-${version_real}",
    default => $target,
  }

  Exec {
    path  => [
      '/usr/local/sbin', '/usr/local/bin',
      '/usr/sbin', '/usr/bin', '/sbin', '/bin',
    ],
    user  => 'root',
    group => 'root',
  }

  archive { "groovy-binary-${version_real}.zip":
    ensure     => present,
    url        => $url_real,
    checksum   => false,
    src_target => '/var/tmp',
    target     => '/opt',
    extension  => 'zip',
    timeout    => $timeout,
    root_dir   => "groovy-${version_real}",
  }

  file { '/etc/profile.d/groovy.sh':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/groovy.sh.erb"),
  }

}
