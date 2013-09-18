class devstack {
    include configs

    package {"git": 
        ensure => installed,
    }

    exec { "git clone https://github.com/openstack-dev/devstack.git":
        cwd => "${configs::vagrant_user_home}",
        creates => "${configs::vagrant_user_home}/devstack",
        path => ["/usr/bin",
                 "/usr/local/bin",
                 "/bin"],
        user => "${configs::vagrant_user}",
        require => [User["${configs::vagrant_user}"], 
                    Package["git"]],
                    #notify {"Cloning devstack":},
    }

    file { "/home/vagrant/devstack":
        ensure => directory,
        require => Exec["git clone https://github.com/openstack-dev/devstack.git"],
    }

    file { "/home/vagrant/adminrc":
        source => "${configs::config_dir}/adminrc",
        owner => "${configs::vagrant_user}",
        group => "${configs::vagrant_user}",
        mode => 0644,
    }

    file { "/home/vagrant/demorc":
        source => "${configs::config_dir}/demorc",
        owner => "${configs::vagrant_user}",
        group => "${configs::vagrant_user}",
        mode => 0644,
    }

    file { "/home/vagrant/devstack/localrc":
        source => "${configs::config_dir}/localrc",
        owner => "${configs::vagrant_user}",
        group => "${configs::vagrant_user}",
        mode => 0644,
        require => File["/home/vagrant/devstack"],
    }

    exec { "/home/vagrant/devstack/stack.sh":
        # creates => "/opt/stack",
        timeout   => 0,
        logoutput => true,
        user      => "${configs::vagrant_user}",
        require   => File["/home/vagrant/devstack/localrc"],
        #notify {"Installing devstack": },
    }
}
