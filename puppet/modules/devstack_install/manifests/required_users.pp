class required_users {
    include configs

    group { "${configs::vagrant_user}":
        ensure => present,
    }

    user { "${configs::vagrant_user}":
        ensure => present
    }
}

