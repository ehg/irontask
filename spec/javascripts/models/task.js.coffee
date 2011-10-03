describe "Task", ->
	taskAttributes =
			text 			: 'A test task'
			done 			: false
			date 			: new Date(2011, 12, 25, 12, 0, 0, 0)
			contexts	: ['Home', 'Work']

	describe "validation", ->
		beforeEach ->
			@task = new Privydo.Models.Task
			@eventSpy = sinon.spy()
			@task.bind("error", @eventSpy)
			@attrs = _.clone taskAttributes
		
		it "should be valid with valid attributes", ->
			@task.set @attrs
			expect(@eventSpy.called).toBeFalsy()

		it "should not be valid without text", ->
			@attrs.text = ''
			@task.set @attrs
			expect(@eventSpy).toHaveBeenCalledOnce()
			expect(@eventSpy).toHaveBeenCalledWith( @task, "no text")

		it "should not be valid if the text is too long", ->
			@attrs.text = 'extremely long taskextremely long taskextremely long taskextremely long taskextremely long task'
			@task.set @attrs
			expect(@eventSpy).toHaveBeenCalledOnce()
			expect(@eventSpy).toHaveBeenCalledWith( @task, "text too long")

		it "should not be valid without done being set", ->
			@attrs.done = 'nonsensical'
			@task.set @attrs
			expect(@eventSpy).toHaveBeenCalledOnce()
			expect(@eventSpy).toHaveBeenCalledWith( @task, "no done")

		it "should not be valid if the date is invalid", ->
			@attrs.date = 'NOT A DATE'
			@task.set @attrs
			expect(@eventSpy).toHaveBeenCalledOnce()
			expect(@eventSpy).toHaveBeenCalledWith( @task, "invalid date")

		it "should be valid without a date", ->
			delete @attrs.date
			@task.set @attrs
			expect(@eventSpy.called).toBeFalsy()

		it "should not be valid without at least one context", ->
			@attrs.contexts = []
			@task.set @attrs
			expect(@eventSpy).toHaveBeenCalledOnce()
			expect(@eventSpy).toHaveBeenCalledWith( @task, "no contexts specified" )

		xit "should not be valid without existing contexts", ->
			# more of an integration test?

	describe "URL", ->
		beforeEach ->
			@task = new Privydo.Models.Task taskAttributes

		it "should have /tasks/{id} as an URL if a task has an ID", ->
			@task.set {id : 580}
			expect(@task.url()).toEqual "/tasks/580"

		it "should have /tasks as an URL if a task has no ID", ->
			expect(@task.url()).toEqual "/tasks"


describe "Task Collection", ->
	[taskStub, model, tasks, task1, task2, task3, task4] = [null, null, null, null, null, null, null]
	
	beforeEach ->
		#models = window["Privydo"]["Models"]
		#taskStub = sinon.stub(models, "Task")
		#model = new Backbone.Model {id: 5, text: "Test"}
		#taskStub.returns(model)
		tasks = new Privydo.Models.DisplayTasks
		task1 = new Privydo.Models.Task {id: 5, text: "Test 1"}
		task2 = new Privydo.Models.Task {id: 4, text: "Test 2", date: new Date(2011, 07, 18, 12, 35, 00, 00)}
		task3 = new Privydo.Models.Task {id: 3, text: "Test 3", date: new Date(2011, 08, 19) }
		task4 = new Privydo.Models.Task {id: 2, text: "Test 4", date: new Date(2011, 07, 18)}
	
	afterEach ->
		#taskStub.restore()
	

	describe "Adding and ordering", ->
		it "should add a model", ->
			tasks.add [task1, task2, task3, task4]
			expect(tasks.length).toEqual(4)
		
		it "should find a model by id", ->
			tasks.add [task1, task2, task3, task4]
			expect(tasks.get(3).get("id")).toEqual(3)
	
		it "should order models by date", ->
			tasks.add [task1, task2, task3, task4]
			expect(tasks.at 0).toBe task4
			expect(tasks.at 1).toBe task2
			expect(tasks.at 2).toBe task3
			expect(tasks.at 3).toBe task1

		it "should order models by date, then order number", ->
			task2.set { date: new Date(2011, 07, 18), order : 1}
			task4.set { order : 2}
			tasks.add [task1, task2, task3, task4]
			expect(tasks.at 0).toBe task2
			expect(tasks.at 1).toBe task4
			expect(tasks.at 2).toBe task3
			expect(tasks.at 3).toBe task1

	describe "Server", ->

		beforeEach ->
			@server = sinon.fakeServer.create()
			@server.respondWith 'GET', '/tasks', @validResponse @fixtures.Tasks.valid.tasks
			@tasks = new Privydo.Models.Tasks
			writeSessionCookie 'key', 'secret'


		afterEach ->
			@server.restore()
			deleteCookie 'key'

		it "should make the correct request", ->
			@tasks.fetch()
			expect(@server.requests.length).toEqual(1)
			expect(@server.requests[0].method).toEqual('GET')
			expect(@server.requests[0].url).toEqual('/tasks')

		it "should parse todos from the response", ->
			@tasks.fetch()
			@server.respond()
			expect(@tasks.length).toEqual(@fixtures.Tasks.valid.tasks.length)
			expect(@tasks.at(0).get('text')).toEqual('test text')

