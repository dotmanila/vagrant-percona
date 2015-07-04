# -*- mode: ruby -*-
# vi: set ft=ruby :

require File.dirname(__FILE__) + '/lib/vagrant-common.rb'

# Number of servers
pxb_servers = 1
pxb_stores = 1

Vagrant.configure("2") do |config|
    config.vm.box = "puppetlabs/centos-6.6-64-puppet"

    # Create the server nodes
    (1..pxb_servers).each do |i|
        name = "pxb-server-" + i.to_s

        config.vm.define name do |node_config|
            node_config.vm.network :private_network, ip: "192.168.56.31"
            node_config.vm.hostname = name
            node_config.vm.provision :hostmanager

            # Provisioners
            provision_puppet( node_config, "pyxbackup_server.pp" ) { |puppet| 
                puppet.facter = {
                    # PXC setup
                    "percona_server_version"  => '56',
                    'innodb_buffer_pool_size' => '128M',
                    'innodb_log_file_size' => '64M',
                    'innodb_flush_log_at_trx_commit' => '0',

                    # Sysbench setup
                    'sysbench_load' => (i == 1 ? true : false ),
                    'tables' => 1,
                    'rows' => 100000,
                    'threads' => 1,
                    'tx_rate' => 5,
                    'schema' => 'sbtest',

                    # TokuDB setup
                    'tokudb_enable' => false,
                    'tokudb_directio' => 'ON',
                    'tokudb_loader_memory_size' => '64M',
                    'tokudb_fsync_log_period' => '0',
                    'tokudb_cache_size' => '128M',
                }
            }

            # Providers
            provider_virtualbox( name, node_config, 1024 ) { |vb, override|
                provision_puppet( override, "pyxbackup_server.pp" ) {|puppet|
                    puppet.facter = {
                        'default_interface' => 'eth1'
                    }
                }
            }

        end
    end

    # Create the storage nodes
    (1..pxb_stores).each do |i|
        name = "pxb-store-" + i.to_s

        config.vm.define name do |node_config|
            node_config.vm.network :private_network, ip: "192.168.56.32"
            node_config.vm.hostname = name
            node_config.vm.provision :hostmanager

            # Provisioners
            provision_puppet( node_config, "pyxbackup_store.pp" ) { |puppet| 
                puppet.facter = {

                }
            }

            # Providers
            provider_virtualbox( name, node_config, 1024 ) { |vb, override|
                provision_puppet( override, "pyxbackup_store.pp" ) {|puppet|
                    puppet.facter = {
                        'default_interface' => 'eth1'
                    }
                }
            }

        end
    end
end