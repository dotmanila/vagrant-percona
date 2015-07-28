class base::hostname {
	exec {
		"set_hostname":
			path    => ["/usr/sbin","/bin","/usr/bin"],
			command => "hostname $vagrant_hostname"
	}
}
