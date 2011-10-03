#= require pidcrypt/sha256
class Privydo.Models.Account extends Backbone.Model
	url: '/account'
	paramRoot: 'user'
	
	validate: (atr) ->
		return "username empty" unless atr.username
		return "password empty" unless atr.password
		
	username_available: (username) ->
		result = false
		res = $.ajax
			url: '/users/username_available'
			type: 'POST'
			contentType: 'application/json'
			dataType: 'json'
			data: JSON.stringify { "username" : username }
			statusCode:
				200: =>
					result = true
					@.trigger 'username_taken', result
				400: =>
					@.trigger 'username_taken', result

	new: (username, plaintext_passwd, magic_word, callbacks) ->
		contexts = new Privydo.Models.Contexts [{text: 'Home', order: 0, selected: true},{text: 'Work', order: 1, selected: false}]
		password = @hash(plaintext_passwd) if plaintext_passwd
		metadata = encrypt JSON.stringify({ contexts : contexts.toJSON()}), password
		@save
			username : username
			password : password
			metadata: metadata
			magic_word: magic_word
		, callbacks

	hash: (password) ->
		pidCrypt.SHA256 password
	
	
