#= require pidcrypt/sha256
#= require cookies
$ ->
	input_username = $('input[name=username]')
	input_password = $('#input_password')
	
	input_password.watermark()
	input_username.watermark().focus()
	
	interval = setInterval ->
		input_username.change() if input_username.val().length > 0
		input_password.change() and clearInterval(interval) if input_password.val().length > 0
	, 100

	$('#login').submit =>
		password = pidCrypt.SHA256 input_password.val()
		writeSessionCookie 'key', password
		$('#password').val password
		
