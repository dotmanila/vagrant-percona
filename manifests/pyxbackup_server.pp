include stdlib 

include base::packages
include base::insecure

class {'base::swappiness':
	swappiness => $swappiness
}

include percona::repository
include percona::toolkit
include percona::sysbench
include percona::xtrabackup

include percona::server
include percona::config
include percona::service
include pyxbackup::server
include pyxbackup::sysbench

include test::user

if $datadir_dev {
	class { 'mysql::datadir':
		datadir_dev => $datadir_dev,
		datadir_dev_scheduler => $datadir_dev_scheduler,
		datadir_fs => $datadir_fs,
		datadir_fs_opts => $datadir_fs_opts,
		datadir_mkfs_opts => $datadir_mkfs_opts
	}

	Class['mysql::datadir'] -> Class['percona::server']
}

Class['percona::repository'] -> Class['percona::server'] -> Class['percona::config'] -> Class['percona::service']

Class['base::packages'] -> Class['percona::repository']
Class['base::insecure'] -> Class['percona::repository']

Class['percona::repository'] -> Class['percona::toolkit']
Class['percona::repository'] -> Class['percona::sysbench']
Class['percona::repository'] -> Class['percona::xtrabackup']

Class['percona::service'] -> Class['test::user']

if $sysbench_load == 'true' {
	class { 'test::sysbench_load':
		schema => $schema,
		tables => $tables,
		rows => $rows,
		threads => $threads,
		engine => $engine
	}
	
	Class['percona::sysbench'] -> Class['test::sysbench_load']
	Class['test::user'] -> Class['test::sysbench_load']
	Class['test::sysbench_load'] -> Class['pyxbackup::server'] -> Class['pyxbackup::sysbench']
}

if $sysbench_skip_test_client != 'true' {
    include test::sysbench_test_script
}

Class['percona::xtrabackup'] -> Class['pyxbackup::server']


