class pyxbackup::server {
    $dirs = [
        "/vagrant/bkp", "/vagrant/bkp/local",
        "/vagrant/bkp/remote", "/vagrant/bkp/local/${hostname}",
        "/vagrant/bkp/remote/${hostname}",
        "/vagrant/bkp/local/${hostname}/stor", 
        "/vagrant/bkp/local/${hostname}/work",
        "/vagrant/bkp/remote/${hostname}/stor",
        "/vagrant/bkp/remote/${hostname}/work"
    ]

    file { 
        '/etc/profile.d/pyxbackup.sh':
            ensure => file,
            source => 'puppet:///modules/pyxbackup/pyxbackup.profile',
            mode => 0755;
        '/etc/init.d/sysbench':
            ensure => file,
            source => 'puppet:///modules/pyxbackup/sysbench.init',
            mode => 0755;
        '/usr/local/bin/pyxbackup':
            ensure => link,
            target => '/vagrant/pyxbackup/pyxbackup',
            mode => 0755;
        '/usr/local/bin/pyxbackup.cnf':
            ensure => file,
            content => template("pyxbackup/pyxbackup.cnf.erb");
        $dirs:
            ensure => directory;
    }

    package {
        "MySQL-python": ensure   => installed;
    }

    host {
        "pxb-store-1":
            ensure => present,
            target => '/etc/hosts',
            ip => '192.168.56.32';
    }
}