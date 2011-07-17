#= require pidcrypt/sha256
$ ->
	$('#login').submit ->
		$('#password').val( pidCrypt.SHA256 $('#password').val() )
		alert $('#password').val()

		
