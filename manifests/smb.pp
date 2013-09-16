class smb {
    include configs

    file {"smb.conf":
        path => "/etc/samba/smb.conf",
        source => "${configs::config_dir}/smb.conf",
    }

    package {"samba":
        ensure => installed,
    }

    service { "smbd":
        ensure => running,
        enable => true,
        subscribe => File["smb.conf"],
        require => Package["samba"],
    }
}

