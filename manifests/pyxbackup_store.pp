include stdlib 

include base::packages
include base::insecure

class {'base::swappiness':
	swappiness => $swappiness
}

include percona::repository
include percona::toolkit
include percona::xtrabackup
include percona::sysbench
include percona::client

include pyxbackup::store

Class['base::packages'] -> Class['percona::repository']
Class['base::insecure'] -> Class['percona::repository']


Class['percona::repository'] -> Class['percona::toolkit']
Class['percona::repository'] -> Class['percona::client'] -> Class['percona::sysbench']
Class['percona::repository'] -> Class['percona::xtrabackup'] -> Class['pyxbackup::store']


