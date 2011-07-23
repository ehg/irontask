describe "Tasks page view", ->
	beforeEach ->
		@view = new Privydo.Views.TaskPage
		@view.render()

	it "renders the new task input box", ->
		expect($(@view.el).find('#add_task').length).toNotEqual(0)

	describe "When text is entered into the input", ->
		beforeEach ->
			$('#add_task').text 'Newwwwwwwww task!'
			e = jQuery.Event 'keydown', { keyCode: 13 }
			$('#add_task').trigger(e)

		it "triggers a save event", ->
			eventSpy = sinon.spy()
			@view.bind "keydown #add_task", eventSpy
			expect(eventSpy).toHaveBeenCalledOnce()
			@view.unbind "keydown #add_task"
