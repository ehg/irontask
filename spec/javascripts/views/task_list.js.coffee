describe "View: TaskList", ->
	beforeEach ->
		@view = new IronTask.Views.TaskList()
		setFixtures "<ul id='#task-list'></ul>"

	describe "Rendering when there are no undone tasks", ->
		beforeEach ->
			@view.collection = new Backbone.Collection [new Backbone.Model {id:1, done: true}]
			@view.collection.notdone = -> []
			@view.addTasks()

		it "should show a message", ->
			expect($(@view.el).find '#task-placeholder').toExist()

	describe "Rendering", ->
		beforeEach ->
			@taskView = new Backbone.View()
			@taskView.render = ->
				@el = document.createElement 'li'
				@
			@taskRenderSpy = sinon.spy @taskView, "render"
			@taskViewStub = sinon.stub(window.IronTask.Views, "Task").returns @taskView
			@task1 = new Backbone.Model {id:1, done: false}
			@task2 = new Backbone.Model {id:2, done: false}
			@task3 = new Backbone.Model {id:3, done: true, doneDate: Date.today()}
			@task4 = new Backbone.Model {id:4, done: true, doneDate: Date.today().addDays(-4)}
			@view.collection = new Backbone.Collection [
				@task1
				@task2
				@task3
				@task4
				@task5
			]
			@view.collection.notdone = -> @filter (task) -> task.get('done') is false
			@view.addTasks()

		afterEach ->
			window.IronTask.Views.Task.restore()

		it "should create a Task view for each task item", ->
			expect(@taskViewStub).toHaveBeenCalledThrice()
			expect(@taskViewStub).toHaveBeenCalledWith({model: @task1})
			expect(@taskViewStub).toHaveBeenCalledWith({model: @task2})
			expect(@taskViewStub).toHaveBeenCalledWith({model: @task3})

		it "should render each Task view", ->
			expect(@taskRenderSpy).toHaveBeenCalledThrice()

		it "appends the task to the task list", ->
			expect($(@view.el).children().length).toEqual(3)

		it "should have the class ui-sortable", ->
			expect(@view.el).toHaveClass 'ui-sortable'
			
