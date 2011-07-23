describe "View: TaskList", ->
	beforeEach ->
		@view = new Privydo.Views.TaskList()

	describe "Instantiation", ->
		it "should create a list element", ->
			expect(@view.el.nodeName).toEqual("UL")

		it "should have a class of 'tasks'", ->
			expect($(@view.el)).toHaveClass('tasks')
	
	describe "Rendering", ->
		beforeEach ->
			@taskView = new Backbone.View()
			@taskView.render = ->
				@el = document.createElement 'li'
				@
			@taskRenderSpy = sinon.spy @taskView, "render"
			@taskViewStub = sinon.stub(window.Privydo.Views, "Task").returns(@taskView)
			@task1 = new Backbone.Model {id:1}
			@task2 = new Backbone.Model {id:2}
			@task3 = new Backbone.Model {id:3}
			@view.collection = new Backbone.Collection [
				@task1
				@task2
				@task3
			]
			@view.render()

		afterEach ->
			window.Privydo.Views.Task.restore()

		it "should create a Task view for each task item", ->
			expect(@taskViewStub).toHaveBeenCalledThrice()
			expect(@taskViewStub).toHaveBeenCalledWith({model: @task1})
			expect(@taskViewStub).toHaveBeenCalledWith({model: @task2})
			expect(@taskViewStub).toHaveBeenCalledWith({model: @task3})

		it "should render each Task view", ->
			expect(@taskRenderSpy).toHaveBeenCalledThrice()

		it "appends the task to the task list", ->
			expect($(@view.el).children().length).toEqual(3)

