include netrc

netrc::foruser{"netrc_myuser": 
	user => 'myuser', 
	machine_user_password_triples => [['myserver.localdomain','myuser','pw'],['mysecondserver.localdomain','myuser','pw2']]
}
