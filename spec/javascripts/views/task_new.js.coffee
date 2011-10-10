describe "Tasks page view", ->
	beforeEach ->
		@view = new Privydo.Views.TaskPage
		setFixtures "<div id='create-task'></div>"
		@view.render()
		@input = $(@view.el).find('#add_task')

	it "renders the new task input box", ->
		expect(@input.length).toNotEqual(0)

	#should stub out collection here
	describe "When text is entered into the input", ->
		beforeEach ->
			@spy = sinon.spy tasks, "create"
			@input.text 'Newwwwwwwww task!'
			e = jQuery.Event 'keypress', { keyCode: 13 }
			@input.trigger e

		afterEach ->
			tasks.create.restore()

		it "triggers a save event", ->
			expect(@spy).toHaveBeenCalled()

		it "clears the text in the box", ->
			expect(@input.val().length).toEqual 0
