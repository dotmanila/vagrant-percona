class pyxbackup::store {
    file { 
        '/etc/profile.d/pyxbackup.sh':
            ensure => file,
            source => 'puppet:///modules/pyxbackup/pyxbackup.profile',
            mode => 0755;
        '/usr/local/bin/pyxbackup':
            ensure => link,
            target => '/vagrant/pyxbackup/pyxbackup',
            mode => 0755;
        "/usr/local/bin/pxb-server-1.cnf":
            ensure => file,
            content => template("pyxbackup/pyxbackup-store.cnf.erb");
    }

    package {
        "MySQL-python": ensure   => installed;
    }
}