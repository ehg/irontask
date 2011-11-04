describe "Tasks Routing", ->

	beforeEach ->
		@routeSpy = sinon.spy()
		@router = new IronTask.Routers.TasksRouter

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
		@router = new IronTask.Routers.TasksRouter
		@collection = new Backbone.Collection
		@fetchStub = sinon.stub(@collection, "fetch").returns(null)
		@taskListViewStub = sinon.stub(window["IronTask"]["Views"], "TaskList").returns(new Backbone.View)
		@taskCollectionStub = sinon.stub(window["IronTask"]["Models"], "Tasks").returns(@collection)
	
	afterEach ->
		window["IronTask"]["Views"].TaskList.restore()
		window["IronTask"]["Models"].Tasks.restore()
	
	describe "Index handler", ->

		describe "when no Task list exists", ->
			
			beforeEach ->
				@router.index()

			it "creates a Task list view", ->
				expect(@taskListViewStub).toHaveBeenCalledOnce()

