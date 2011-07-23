describe "Tasks Routing", ->

	beforeEach ->
		@routeSpy = sinon.spy()
		@router = new Privydo.Routers.TasksRouter

	afterEach ->
		window.location.hash = ""
		Backbone.history and (Backbone.history.handlers = [])

	it "fires the index route with a blank hash", ->
		@router.bind "route:index", @routeSpy
		window.location.hash = ""
		Backbone.history.start()
		expect(@routeSpy).toHaveBeenCalledOnce()
		expect(@routeSpy).toHaveBeenCalledWith()
		@router.unbind("route:index")

describe "Tasks Routes", ->

	beforeEach ->
		@router = new Privydo.Routers.TasksRouter
		@collection = new Backbone.Collection
		@fetchStub = sinon.stub(@collection, "fetch").returns(null)
		@taskListViewStub = sinon.stub(window["Privydo"]["Views"], "TaskList").returns(new Backbone.View)
		@taskCollectionStub = sinon.stub(window["Privydo"]["Models"], "Tasks").returns(@collection)
	
	afterEach ->
		window["Privydo"]["Views"].TaskList.restore()
		window["Privydo"]["Models"].Tasks.restore()
	
	describe "Index handler", ->

		describe "when no Task list exists", ->
			
			beforeEach ->
				@router.index()

			it "creates a Task list collection", ->
				expect(@taskCollectionStub).toHaveBeenCalledOnce()
				expect(@taskCollectionStub).toHaveBeenCalledWithExactly()

			it "creates a Task list view", ->
				expect(@taskListViewStub).toHaveBeenCalledOnce()
				expect(@taskListViewStub).toHaveBeenCalledWith( {collection: @collection} )

			it "fetches the Task list from the server", ->
				expect(@fetchStub).toHaveBeenCalledOnce()
				expect(@fetchStub).toHaveBeenCalledWith()


