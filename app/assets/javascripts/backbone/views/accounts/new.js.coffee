#=require password_strength_plugin
class Privydo.Views.Signup extends Backbone.View
	template: JST["backbone/templates/accounts/new"]
	events:{
		"submit form" : "new"
		}

	initialize: ->
		_.bindAll(this, "render")
		@model.bind 'username_taken', @is_username_taken, this
		@valid_confirm_password_debounce = _.debounce @valid_confirm_password, 1000
		@username_taken_debounce = _.debounce @username_taken, 700
		@render()
	
	new: ->
		plaintext = this.$('[name=password]').val()
		contexts = new Privydo.Models.Contexts [{text: 'Home', order: 0, selected: true},{text: 'Work', order: 1, selected: false}]
		password = Privydo.Models.Account.hash(plaintext) if plaintext
		metadata = encrypt JSON.stringify({ contexts : contexts.toJSON()}), password
	
		this.model.save { username : this.$('[name=username]').val(), password : password, metadata: metadata, magic_word: $('input[name=secret]').val()},
			success: (model, response) =>
				new Privydo.Views.Notice { message : "Thanks! We'll now take you to the sign in page." }
				setTimeout ->
					window.location.replace("/user_session/new")
				, 2000
			error: (model, response) ->
				new Privydo.Views.Error({message: response.responseText or response})
		return false

	render: ->
		$(@el).html this.template()
		$('#app').html @el
		$('input[name=password]').passStrength {userid: $('input[name=username]')}
		$('input[name=password]').keyup (event) =>
			if event.keyCode != 9
				@is_password_empty()
				@passwords_are_same() if $('input[name=confirm_password]').val().length > 0

		$('input[name=confirm_password]').keyup (event) =>
			@valid_confirm_password_debounce() if event.keyCode != 9

		$('input[name=username]').blur =>
			@username_taken unless @is_username_empty()

		$('input[name=username]').keyup (event) =>
			if event.keyCode != 9
				console.log @is_username_empty()
				@username_taken_debounce() unless @is_username_empty()

		$('div.submit button').click (event) =>
			@valid_confirm_password();@is_username_empty();@is_password_empty()
			event.preventDefault() or @shake_button() unless @is_valid_username and @is_valid_password and @is_valid_confirm_password
		@
	
	is_password_empty: ->
		if $('input[name=password]').val().length == 0
			$('#sidetip-password').text "A password is required!"
			$('#sidetip-password').attr 'class', 'error'
			@is_valid_password = false
		else
			@is_valid_password = true


	valid_confirm_password: ->
		if $('input[name=confirm_password]').val().length == 0
			$('#sidetip-confirm_password').text "Please confirm your password!"
			$('#sidetip-confirm_password').attr 'class', 'error'
			@is_valid_confirm_password = false
		else
			@passwords_are_same()
				
	passwords_are_same: ->
		if $('input[name=password]').val() != $('input[name=confirm_password]').val()
			$('#sidetip-confirm_password').text "This doesn't match your password!"
			$('#sidetip-confirm_password').attr 'class', 'error'
			@is_valid_confirm_password = false
		else
			$('#sidetip-confirm_password').text "Passwords match!"
			$('#sidetip-confirm_password').attr 'class', 'valid'
			@is_valid_confirm_password = true


	is_username_empty: ->
		if $('input[name=username]').val().length == 0
			$('#sidetip-username').text "A user name or email address is required!"
			$('#sidetip-username').attr 'class', 'error'
			@is_valid_username = false
			return true
		@is_valid_username = true
		false

	username_taken: ->
		username = $('input[name=username]').val()
		@model.username_available username

	is_username_taken: (taken) ->
		if taken
			$('#sidetip-username').text "Fantastic, that's available."
			$('#sidetip-username').attr 'class', 'valid'
			@is_valid_username = true
		else
			$('#sidetip-username').text "That's taken :( Please choose another."
			$('#sidetip-username').attr 'class', 'error'
			@is_valid_username = false

	shake_button: ->
		$('div.submit button').effect 'shake', {times: 3, distance: 5}, 100
