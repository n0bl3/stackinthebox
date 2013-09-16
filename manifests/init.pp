$config_dir = "/vagrant/configs"
$vagrant_user = "vagrant"
$vagrant_user_home = "/home/vagrant"

group { "puppet":
    ensure => "present",
}

package {"git": 
    ensure => installed,
}

file {"smb.conf":
    path => "/etc/samba/smb.conf",
    source => "${config_dir}/smb.conf",
}

package {"samba":
    ensure => installed,
    require => File["smb.conf"],
}

service { "smbd":
    enable => true,
    require => [Package["samba"],
                File["smb.conf"]],
}

user { $vagrant_user:
    ensure => present
}

exec { "git clone https://github.com/openstack-dev/devstack.git":
    cwd => $vagrant_user_home,
    creates => "${vagrant_user_home}/devstack",
    path => ["/usr/bin",
             "/usr/local/bin",
             "/bin"],
    user => $vagrant_user,
    require => [User[$vagrant_user], 
                Package["git"]]
}

file { "/home/vagrant/devstack":
    ensure => directory,
    require => Exec["git clone https://github.com/openstack-dev/devstack.git"],
}

file { "/home/vagrant/adminrc":
    source => "${config_dir}/adminrc",
    owner => $vagrant_user,
    group => $vagrant_user,
    mode => 0644,
}

file { "/home/vagrant/demorc":
    source => "${config_dir}/demorc",
    owner => $vagrant_user,
    group => $vagrant_user,
    mode => 0644,
}

file { "/home/vagrant/devstack/localrc":
    source => "${config_dir}/localrc",
    owner => $vagrant_user,
    group => $vagrant_user,
    mode => 0644,
    require => File["/home/vagrant/devstack"],
}

exec { "/home/vagrant/devstack/stack.sh":
    # creates => "/opt/stack",
    timeout => 0,
    logoutput => true,
    user => $vagrant_user,
    require => File["/home/vagrant/devstack/localrc"],
}
