#= require pidcrypt/sha256
class Privydo.Models.Account extends Backbone.Model
	url: '/account'
	paramRoot: 'user'
	valid_username: false
	valid_password: false
	valid_confirm_password: false

	initialize: ->
		@bind 'username_taken', @username_is_taken, this

	validate: (atr) ->
		return "username empty" unless atr.username
		return "password empty" unless atr.password
		
	validate_username: (username) ->
		if username.length == 0
			@valid_username = false
			return @valid_username
		@username_available(username)
		return true

	username_is_taken: (result) =>
#		@valid_username = !result

	validate_password: (password) ->
		@valid_password = password.length != 0

	validate_confirm: (password, confirm_passwd, callbacks) ->
		@valid_confirm_password = false
		callbacks.empty() if confirm_passwd.length == 0
		callbacks.donotmatch() if password != confirm_passwd and confirm_passwd.length != 0
		callbacks.success() and @valid_confirm_password = true if password == confirm_passwd and confirm_passwd.length != 0

	valid_fields: ->
		@valid_username and @valid_password and @valid_confirm_password

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
			error: (e)=>
				@.trigger 'username_taken', result
				@.trigger 'error', "could not contact server"

	new: (username, plaintext_passwd, magic_word, callbacks) ->
		contexts = new Privydo.Models.Contexts [{text: 'Home', order: 0, selected: true},{text: 'Work', order: 1, selected: false}]
		password = @hash(plaintext_passwd) if plaintext_passwd
		metadata = JSON.stringify({ contexts : contexts.toJSON()})#,encrypt JSON.stringify({ contexts : contexts.toJSON()}), password
		@save
			username : username
			password : password
			metadata: metadata
			magic_word: magic_word
		, callbacks

	hash: (password) ->
		pidCrypt.SHA256 password
	
	
