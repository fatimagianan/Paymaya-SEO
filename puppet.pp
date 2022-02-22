node "your fqdn here" {
package { 'vim-enhanced':
        ensure => present,
}
package { 'git':
        ensure => present,
}
package { 'curl':
        ensure => present,
}
package { 'wget':
        ensure => present,
}
user { 'monitor':
        ensure => present,
        shell => '/bin/bash',
        home => '/home/monitor',
        managehome => true,
}
file { '/home/monitor/scripts/':
        ensure => 'directory',
        owner  => 'monitor',
        mode   => '0750',
}
exec { 'wget':
        command => '/usr/bin/wget https://raw.githubusercontent.com/fatimagianan/Paymaya-SEO/master/memory_check.sh -O /home/monitor/scripts/memory_check; chmod +x /home/monitor/scripts/memory_check',
        creates => '/home/monitor/scripts/memory_check',
        require => Package['wget'],
        path   => '/usr/bin:/usr/sbin:/bin',
        tries => '3',
        logoutput => 'on_failure',
}
file { '/home/monitor/src/':
        ensure => 'directory',
        owner  => 'monitor',
        mode   => '0750'
}
file { '/home/monitor/src/my_memory_check':
        ensure => 'link',
        target => '/home/monitor/scripts/memory_check',
        owner  => 'monitor',
        mode   => '0750'
}
cron {'cron':
        command => "/home/monitor/src/my_memory_check",
        minute => '*/10',
        hour => '*',
        month => '*',
        weekday  => '*',
        monthday => '*',
}
}
