#= require pidcrypt/sha256
#= require cookies
$ ->
	$('#login').submit ->
		password = pidCrypt.SHA256 $('#input_password').val()
		writeSessionCookie 'key', password
		$('#password').val password

		
