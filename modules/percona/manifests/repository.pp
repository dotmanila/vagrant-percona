class percona::repository {
	
	if( $experimental_repo == undef ) {
		$experimental_repo = 'no'
	}

	case $operatingsystem {
		ubuntu: {
			exec { "apt-key":
				command => "apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A",
				unless => "apt-key list | grep -i percona",
				path => "/usr/bin:/bin";
			}
		
			case $experimental_repo {
				'no': { $repo = "deb http://repo.percona.com/apt precise main
deb-src http://repo.percona.com/apt precise main
"}
				'yes': { $repo = "deb http://repo.percona.com/apt precise experimental
deb-src http://repo.percona.com/apt precise experimental
" }
			}

			file { "/etc/apt/sources.list.d/percona-repo.list":
				content => $repo,
				notify  => Exec["percona-apt-update"]
			}
			
			exec { "percona-apt-update":
				command => "apt-get update",
				require => [File['/etc/apt/sources.list.d/percona-repo.list'], Exec['apt-key']],
				path => "/usr/bin:/bin",
				refreshonly => true
			}
		}
		centos: {
			package {
				"percona-release":
					source => "http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm",
					provider => "rpm";
			}

		}
	}

}
