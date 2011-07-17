class Privydo.Views.Signup extends Backbone.View
	template: JST["backbone/templates/accounts/new"]
	
	events:{
		"submit form" : "new"
		}

	initialize: ->
		_.bindAll(this, "render")
		@render()
	
	new: ->
		plaintext = this.$('[name=password]').val()
		confirm_password = this.$('[name=confirm_password]').val()
		if plaintext !=  confirm_password
			new Privydo.Views.Error({message: "Passwords don't match"})
			return false
		#password length check
		#move to somewhere less lame
		password = Privydo.Models.Account.hash(plaintext) if plaintext
		this.model.save { username : this.$('[name=username]').val(), password : password },
			success: (model, response) ->
				# go to tasks page with ?new=1
			error: (model, response) ->
				new Privydo.Views.Error({message: response.responseText or response})
		return false

	render: ->
		$(this.el).html(this.template(this.options.model.toJSON() ))
		$('#app').html(this.el)
		this.delegateEvents()


