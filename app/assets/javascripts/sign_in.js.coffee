#= require pidcrypt/sha256
#= require cookies
$ ->
	$('#input_password').watermark()
	$('input[name=username]').watermark().focus()
	$('#login').submit ->
		password = pidCrypt.SHA256 $('#input_password').val()
		writeSessionCookie 'key', password
		$('#password').val password

		
