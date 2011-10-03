describe "Sign up view", ->

	beforeEach ->
		model = new Backbone.Model { username: 'chris' }
		model.username_available = (username) ->
			result = username != 'chris'
			console.log 'chris'
			@.trigger 'username_taken', result
			
		@view = new Privydo.Views.Signup {model: model}
		setFixtures "<div id='app'></div>"
	
	it "should create a form element", ->
		expect(@view.el.nodeName).toEqual("DIV")
	
	xit "should have a class of 'signup'", ->
		expect($(@view.el)).toHaveClass('signup')

	it "returns the view object", ->
		expect(@view.render()).toEqual(@view)


	describe "Validation", ->

		beforeEach ->
			@view.render()

		describe "Next to username field", ->
			beforeEach ->
				@sidetip = $(@view.el).find('#sidetip-username')
				@field = $(@view.el).find('input[name=username]')
				@spy = sinon.spy @view, "is_username_empty"

			it "displays a username input and sidetip", ->
				expect(@field).toBeVisible()
				expect(@sidetip).toBeVisible()

			it "checks if username is empty on blur", ->
				@field.blur()
				expect(@spy).toHaveBeenCalledOnce()

			it "checks if username is empty on keyup", ->
				@field.keyup()
				expect(@spy).toHaveBeenCalledOnce()

			it "shows an error if the username is empty", ->
				@view.is_username_empty()
				expect(@sidetip).toHaveText "A user name or email address is required!"
				expect(@sidetip).toHaveClass 'error'

			it "shows an error if the username is already taken", ->
				@field.val 'chris'
				@field.blur()
				expect(@sidetip).toHaveText "That's taken :( Please choose another."
				expect(@sidetip).toHaveClass 'error'

		describe "Next to password field", ->
			beforeEach ->
				@sidetip = $(@view.el).find('#sidetip-password')
				@field = $(@view.el).find('input[name=password]')

			it "displays a password input and a sidetip", ->
				expect(@sidetip).toBeVisible()
				expect(@field).toBeVisible()
			
			it "calls the password strength checker when text is typed into the field", ->
				sinon.spy jQuery.fn, "teststrength"
				@field.val "blah"
				@field.keyup()
				expect(jQuery.fn.teststrength).toHaveBeenCalledOnce()
				jQuery.fn.teststrength.restore()

			it "shows an error when the password is weak", ->
				@field.val "aaaaaa"
				@field.keyup()
				expect(@sidetip).toHaveText "That isn't very secure."
				expect(@sidetip).toHaveClass('badPass')

			it "shows an error when the password is empty", ->
				@field.keyup()
				expect(@sidetip).toHaveText('A password is required!')
				expect(@sidetip).toHaveClass('error')

			it "shows a message saying the password is good when the password is good", ->
				@field.val "sdfhsdfsdfsd34"
				@field.keyup()
				expect(@sidetip).toHaveText "That's relatively secure..."
				expect(@sidetip).toHaveClass('goodPass')

			it "shows an error when the password is less than 6 characters long", ->
				@field.val "12345"
				@field.keyup()
				expect(@sidetip).toHaveText "That's too short."
				expect(@sidetip).toHaveClass('shortPass')


		describe "Next to confirm password field, when blurred", ->
			beforeEach ->
				@confirm_password = $(@view.el).find('input[name=confirm_password]')
				@confirm_tip = $(@view.el).find('#sidetip-confirm_password')

			it "displays a confirm password box and sidetip", ->
				expect(@confirm_password).toBeVisible()
				expect(@confirm_tip).toBeVisible()

			xit "checks the passwords match 1 second after last input", ->
				spy = sinon.spy @view, "valid_confirm_password"
				jasmine.Clock.useMock()

				@confirm_password.val 'te'
				@confirm_password.keyup()
				@confirm_password.val 'test'
				@confirm_password.keyup()

				jasmine.Clock.tick(2000)

				console.log spy.callCount
				expect(spy).toHaveBeenCalled()

			it "shows an error if the password doesn't match the confirmed password", ->
				@confirm_password.val 'test'
				$(@view.el).find('input[name=password]').val 'notsame'
				@view.valid_confirm_password()
				expect(@confirm_tip).toHaveText "This doesn't match your password!"
				expect(@confirm_tip).toHaveClass "error"
		
			it "shows an error when the field is empty", ->
				@confirm_password.val ''
				@view.valid_confirm_password()
				expect(@confirm_tip).toHaveText "Please confirm your password!"
				expect(@confirm_tip).toHaveClass "error"

			it "shows a message when the password matches", ->
				@confirm_password.val 'verymuchsame'
				$(@view.el).find('input[name=password]').val 'verymuchsame'
				@view.valid_confirm_password()
				expect(@confirm_tip).toHaveText "Passwords match!"
				expect(@confirm_tip).toHaveClass "valid"
			
			it "checks the confirmed password when the password is modified (only when password not empty)", ->
				spy = sinon.spy @view, "passwords_are_same"
				@confirm_password.val 'verymuchsame'
				$(@view.el).find('input[name=password]').val 'verymuchsame'
				@view.valid_confirm_password()
				$(@view.el).find('input[name=password]').val 'verymuchnotsame'
				$(@view.el).find('input[name=password]').keyup()
				expect(spy).toHaveBeenCalledTwice()

		it "shakes the sign me up button and doesn't submit the form if there are errors", ->
			#
	
	xit "submits the login form when the Sign up button is pressed", ->
		@view.render()
		expect(@view.el).toBeTruthy()
		expect(@view.el.find('input').is('input')).toBeTruthy()



