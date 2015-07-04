class percona::xtrabackup {
    package {
        "percona-xtrabackup": ensure   => installed;
        "qpress": ensure => installed;
        "nc": ensure => installed;
    }
}
