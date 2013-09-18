class devstack_install {
    include configs
    include required_users
    include devstack
    include smb

    notify {'Devstack installation':}
}

