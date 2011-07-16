#= require pidcrypt/sha256
class Privydo.Models.Account extends Backbone.Model
	url: 'account'
	
	validate: (atr) ->
		return "username empty" unless atr.username
		return "password empty" unless atr.password
		
	@hash: (password) ->
		pidCrypt.SHA256 password
	
	
