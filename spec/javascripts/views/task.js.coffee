describe "Task view", ->
	beforeEach ->
		$.fx.off = true
		@model = new Backbone.Model
			id: 1
			text: "My task"
			date: new Date(2011, 6, 20)
			done: false
		@model.save = ->
			'woot'
		@model.setDone = ->
			@set {'done':true}
		@model.putOff = ->
			'woot'
		@view = new Privydo.Views.Task( {model: @model} )
		setFixtures '<ul id="tasks"></ul>'

	afterEach ->
		$.fx.off = false

	describe "Rendering", ->
		beforeEach ->
			$('#tasks').append(@view.render().el)
			@task = $('ul#tasks li:first')

		it "returns the view object", ->
			expect(@view.render()).toEqual(@view)

		it "has the correct text", ->
			expect(@task.find('.task .task_text')).toHaveText('My task')

		it "has the correct date", ->
			expect(@task.find('.task .task_date')).toHaveText('20/7/2011')

		it "hides the task menu", ->
			expect(@task.find('.task-menu .tick')).toBeHidden()
			expect(@task.find('.task-menu .putoff')).toBeHidden()

		it "shows the task menu when the mouse is over the task", ->
			runs ->
				@task.hover()
			waits 200
			runs ->
				expect(@task.find('.task-menu .tick')).toBeVisible()
				expect(@task.find('.task-menu .putoff')).toBeVisible()
		
		it "should have a date class", ->
			expect(@task).toHaveClass '2072011'

		describe "Different dates", ->

			it "adds the overdue class to overdue tasks", ->
				@model.set {'date' : new Date(2011, 6, 22)}
				@view = new Privydo.Views.Task {model: @model}
				$('#tasks').html(@view.render().el)
				@task = $('ul#tasks li:first')
				expect(@task).toHaveClass 'overdue'
				
			it "shows yesterday's date as 'Yesterday'", ->
				@model.set {'date' : Date.today().addDays(-1)}
				@view = new Privydo.Views.Task {model: @model}
				$('#tasks').html(@view.render().el)
				@task = $('ul#tasks li:first .task .task_date')
				expect(@task).toHaveText 'Yesterday'

			it "shows today's date as 'Today' and makes it bold", ->
				@model.set {'date' : Date.today()}
				@view = new Privydo.Views.Task {model: @model}
				$('#tasks').html(@view.render().el)
				@task = $('ul#tasks li:first')
				expect(@task).toHaveClass 'today'
				expect(@task.find '.task .task_date').toHaveText 'Today'

			it "shows tomorrow's date as 'Tomorrow'", ->
				@model.set {'date' : Date.today().addDays(1)}
				@view = new Privydo.Views.Task {model: @model}
				$('#tasks').html(@view.render().el)
				@task = $('ul#tasks li:first .task .task_date')
				expect(@task).toHaveText 'Tomorrow'

			it "shows a date in the next 7 days as its day name", ->
				@model.set {'date' : Date.today().addDays(4)}
				@view = new Privydo.Views.Task {model: @model}
				$('#tasks').html(@view.render().el)
				@task = $('ul#tasks li:first .task .task_date')
				name = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
				expect(@task).toHaveText name[@model.get('date').getDay()]

		describe "When a change event is received", ->
			it "rerenders the task", ->
				spy = sinon.spy @view, "setContent"
				@model.trigger 'change'
				expect(spy).toHaveBeenCalled()

		describe "When a task is done", ->
			it "shows a strikethroughed task if it was marked as done today", ->
				@model.set {'done' : true, 'doneDate' : Date.today()}
				@view = new Privydo.Views.Task {model: @model}
				$('#tasks').html(@view.render().el)
				@task = $('ul#tasks li:first')
				expect(@task).not.toBeNull()
				expect(@task).toHaveClass 'done-task'

			# this logic is in the task list
			xit "does not show the task if it was not done today", ->
				@model.set {'done' : true, 'doneDate' : Date.today().addDays(-4)}
				@view = new Privydo.Views.Task {model: @model}
				$('#tasks').html(@view.render().el)
				@task = $('ul#tasks li:first')
				expect(@task).toBeNull()

			it "does not show the task menu on hover", ->
				@model.set {'done' : true, 'doneDate' : Date.today()}
				@view = new Privydo.Views.Task {model: @model}
				$('#tasks').html(@view.render().el)
				@task = $('ul#tasks li:first')
				@task.hover()
				expect(@task.find('.task-menu .tick')).not.toBeVisible()
				expect(@task.find('.task-menu .putoff')).not.toBeVisible()

		describe "When task has no date", ->
			beforeEach ->
				@model.set {'date' : null }
				@view = new Privydo.Views.Task {model: @model}
				$('#tasks').html(@view.render().el)
				@task = $('ul#tasks li:first')

			it "should display an add date button", ->
				expect(@task.find '.task .task_date span').toHaveText('[Add date]')

			it "should have a no date class", ->
				expect(@task).toHaveClass('no-date')

			it "should call edit mode if add date button clicked", ->
				ev = $.Event 'click'
				ev.srcElement = {}
				ev.srcElement.className = 'task_date'
				@task.find('.task .task_date span').trigger ev
				expect(@task).toHaveClass 'editing_task_date'
	
		describe "When tick clicked", ->
			it "calls the done method", ->
				saveSpy = sinon.spy @model, "setDone"
				@task.find('.tick').click()
				expect(saveSpy).toHaveBeenCalled()
				expect(@task).toHaveClass('done-task')

		describe "When put off clicked", ->
			it "calls the put off method", ->
				saveSpy = sinon.spy @model, "putOff"
				@task.find('.putoff').click()
				expect(saveSpy).toHaveBeenCalled()

		describe "When task text double clicked", ->
			beforeEach ->
				@ev = $.Event 'dblclick'
				@ev.srcElement = {}
				@ev.srcElement.className = 'task_text'
				@task.find('.task_text').trigger @ev

			it "changes the class to editing", ->
				expect(@task).toHaveClass 'editing_task_text'

			it "should not show the task menu", ->
				@task.hover()
				expect($('.task-menu .tick')).toBeHidden()
				expect($('.task-menu .putoff')).toBeHidden()

			describe "When return pressed in edit text", ->
				it "saves the task", ->
					spy = sinon.spy @model, "save"
					e = $.Event 'keypress'
					e.keyCode = $.ui.keyCode.ENTER
					e.srcElement = {}
					e.srcElement.className = 'task_text'
					@task.find('input[name=text_input]').trigger e
					expect(@task).not.toHaveClass 'editing_task_text'
					expect(spy).toHaveBeenCalled()

			describe "When input blurred in edit text", ->
				it "saves the task", ->
					spy = sinon.spy @model, "save"
					e = $.Event 'blur'
					e.srcElement = {}
					e.srcElement.className = 'task_text'
					@task.find('input[name=text_input]').trigger e
					expect(@task).not.toHaveClass 'editing_task_text'
					expect(spy).toHaveBeenCalled()

			describe "When return pressed in edit date", ->
				it "saves the task", ->
					spy = sinon.spy @model, "save"
					e = $.Event 'keypress'
					e.keyCode = $.ui.keyCode.ENTER
					e.srcElement = {}
					e.srcElement.className = 'task_date'
					@task.find('input[name=date_input]').trigger e
					expect(@task).not.toHaveClass 'editing_task_date'
					expect(spy).toHaveBeenCalled()

			describe "When input blurred in edit date", ->
				it "saves the task", ->
					spy = sinon.spy @model, "save"
					e = $.Event 'blur'
					e.srcElement = {}
					e.srcElement.className = 'task_date'
					@task.find('input[name=date_input]').trigger e
					expect(@task).not.toHaveClass 'editing_task_date'
					expect(spy).toHaveBeenCalled()

