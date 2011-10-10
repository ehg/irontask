#=require password_strength_plugin
class Privydo.Views.Signup extends Backbone.View
	template: JST["backbone/templates/accounts/new"]
	
	events:{
		"keyup input[name=username]" : "username_keyup"
		"blur input[name=username]" : "username_blur"
		"keyup input[name=password]" : "password_keyup"
		"keyup input[name=confirm_password]" : "confirm_password_keyup"
		"click div.submit button" : "submit_click"
		"submit form" : "new"
		}

	initialize: ->
		_.bindAll this, "render"
		@render()
		@model.bind 'username_taken', @is_username_taken, this
		@valid_confirm_password_debounce = _.debounce @valid_confirm_password, 700
		@username_taken_debounce = _.debounce @username_taken, 700
	
	render: ->
		$(@el).html this.template()
		$('#app').html @el #attach to different el
		@set_fields()
		@password_input.passStrength {userid: @username_input}
		@
	
	set_fields: ->
		@username_input = @$('input[name=username]')
		@password_input = @$('input[name=password]')
		@confirm_input = @$('input[name=confirm_password]')
		@magic_input = @$('input[name=secret]')

	new: (event) ->
		event.preventDefault()
		@model.new @username_input.val(), @password_input.val(), @magic_input.val(),
			success: (model, response) =>
				new Privydo.Views.Notice { message : "Thanks! We'll now take you to the sign in page." }
				setTimeout ->
					window.location.replace("/user_session/new")
				, 2000
			error: (model, response) ->
				new Privydo.Views.Error {message: response.responseText or response}

	# Events
	username_keyup: (event) =>
		if event.keyCode != 9
			@username_taken_debounce()
	
	username_blur: =>
		@username_taken()
	
	password_keyup: (event) =>
		if event.keyCode != 9
			@is_password_empty()
			@valid_confirm_password() if @confirm_input.val().length > 0

	confirm_password_keyup: (event) =>
		@valid_confirm_password_debounce() if event.keyCode != 9

	submit_click: (event) ->#shorten lines!
		@valid_confirm_password();@username_taken();@is_password_empty()
		event.preventDefault() or @shake_button() unless @model.valid_fields()

	is_password_empty: ->
		if !@model.validate_password @password_input.val()
			$('#sidetip-password').text "A password is required!"
			$('#sidetip-password').attr 'class', 'error'

	valid_confirm_password: ->
		@model.validate_confirm @password_input.val(), @confirm_input.val(),
			empty: =>
				@$('#sidetip-confirm_password').text "Please confirm your password!"
				@$('#sidetip-confirm_password').attr 'class', 'error'
			donotmatch: =>
				@$('#sidetip-confirm_password').text "This doesn't match your password!"
				@$('#sidetip-confirm_password').attr 'class', 'error'
			success: =>
				@$('#sidetip-confirm_password').text "Passwords match!"
				@$('#sidetip-confirm_password').attr 'class', 'valid'

	username_taken: ->
		if !@model.validate_username(@username_input.val())
			@$('#sidetip-username').text	"A user name or email address is required!"
			@$('#sidetip-username').attr 'class', 'error'

	is_username_taken: (available) ->
		if available
			@$('#sidetip-username').text "Fantastic, that's available."
			@$('#sidetip-username').attr 'class', 'valid'
			@model.valid_username = true
		else
			@$('#sidetip-username').text "That's taken :( Please choose another."
			@$('#sidetip-username').attr 'class', 'error'

	shake_button: ->
		@$('div.submit button').effect 'shake', {times: 3, distance: 5}, 100
