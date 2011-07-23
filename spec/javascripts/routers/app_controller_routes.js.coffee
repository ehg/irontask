describe "Sign up routes", ->
	controller = new Privydo.Routers.App

	beforeEach ->
		@routeSpy = sinon.spy()
	
	afterEach ->
		window.location.hash = ""
	
	it "fires the index route with a blank hash", ->
		controller.bind "route:index", @routeSpy
		window.location.hash = ""
		Backbone.history.start()
		expect(@routeSpy).toHaveBeenCalledOnce()
		expect(@routeSpy).toHaveBeenCalledWith()
		controller.unbind("route:index")

