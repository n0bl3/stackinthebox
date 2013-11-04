exec {"fix-missing":
    command => "sudo apt-get update --fix-missing",
    path    => ["/usr/bin", "/usr/sbin"]
}

package {"vim":
    ensure  => installed,
    require => Exec["fix-missing"]
}

package {"git":
    ensure  => installed,
    require => Exec["fix-missing"]
}

exec {"git init":
    command => "git init && git remote add origin https://github.com/n0bl3/home_configs.git && git pull origin master",
    path    => ["/usr/bin", "/usr/sbin"],
    creates => "/home/vagrant/.git",
    cwd     => "/home/vagrant",
    user    => "vagrant",
    group   => "vagrant",
    require => Package["git"]
}

exec {"git clone gearbox":
    command => "git clone git@github.com:getgearbox/gearbox.git",
    creates => "/home/vagrant/gearbox",
    path    => ["/usr/bin", "/usr/sbin"],
    user => "vagrant",
    group => "vagrant",
    cwd => "/home/vagrant",
    require => Package["git"]
}
