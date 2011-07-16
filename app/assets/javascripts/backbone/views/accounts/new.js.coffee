class Privydo.Views.Signup extends Backbone.View
	template: JST["backbone/templates/accounts/new"]
	
	events:{
		"submit form" : "new"
		}
	
	new: ->
		password = Privydo.Models.Account.hash(@$('[name=password]').val())
		@model.save { username : @$('[name=username]').val()
			      password : password },
				
				success: (model, response) ->
					alert('test')
				error: (model, response) ->
					alert('fail')
	render: ->
		alert 'render'
		$(@el).html(@template(@options.model.toJSON()))
		return this
