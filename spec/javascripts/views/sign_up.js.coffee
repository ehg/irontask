describe "sign up view", ->

	beforeEach ->
		@view = new Privydo.Views.Signup
	

	it "should create a form element", ->
		expect(@view.el.nodeName).toEqual("FORM")
	
	it "should have a class of 'signup'", ->
		expect($(@view.el)).toHaveClass('signup')

	xit "returns the view object", ->
		expect(@view.render()).toEqual(@view)

	xit "shows an error if the passwords do not match", ->

	xit "shows errors if the username & password are empty", ->

	xit "submits the login form when the Sign up button is pressed", ->
		@view.render()
		expect(@view.el).toBeTruthy()
		expect(@view.el.find('input').is('input')).toBeTruthy()


	
