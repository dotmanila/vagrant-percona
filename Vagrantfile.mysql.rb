# -*- mode: ruby -*-
# vi: set ft=ruby :

require File.dirname(__FILE__) + '/lib/vagrant-common.rb'

mysql_version = "56"
name = "57-community-tpcc"

Vagrant.configure("2") do |config|
	# Every Vagrant virtual environment requires a box to build off of.
	config.vm.box = "puppetlabs/centos-6.6-64-puppet"

  # Provisioners
  provision_puppet( config, "base.pp" )
  provision_puppet( config, "mysql_server.pp" ) { |puppet|
    puppet.facter = {
      "enable_56" => 1,
      "enable_57" => 0,
    	"innodb_buffer_pool_size"	=> "128M",
    	"innodb_log_file_size"		=> "64M"
    }
  }
  provision_puppet( config, "mysql_client.pp" ) { |puppet|
    puppet.facter = {
      "enable_56" => 1,
      "enable_57" => 0
    }
  }

  # Providers
  provider_virtualbox( name, config, 256 ) { |vb, override|
    # If we are using Virtualbox, override percona_server.pp with the right device for the datadir
    provision_puppet( override, "mysql_server.pp" ) {|puppet|
    }
  }


end