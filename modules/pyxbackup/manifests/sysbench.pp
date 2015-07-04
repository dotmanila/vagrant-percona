class pyxbackup::sysbench {
    service {
        sysbench: ensure => running;
    }
}