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

	@hash: (password) ->
		pidCrypt.SHA256 password
	
	
