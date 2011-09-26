#=require datejs/date-en-GB
class Privydo.Views.TaskList extends Backbone.View
	tagName: 'ul'
	className: 'tasks'
	el: '#app'

	selectedContexts: []

	setSelectedContexts: (contexts) ->
		display_tasks.reset tasks.filterWithContexts(contexts)
		@addTasks()

	initialize: ->
		_.bindAll(this, 'render', 'addTasks', 'addTask', 'change')
		rubbish = new Privydo.Views.Rubbish
		$('#task-list').sortable {}
			scroll: false
			start: (event, ui) =>
				klass = $(ui.item).attr 'class'
				klass = klass.split(' ')[0]
				console.log klass
				$('#task-list').sortable('option', 'items', ".#{klass}")
				$('#task-list').sortable('refresh')
				rubbish.render()
			update: (event, ui) =>
				tasks = @$('li')
				for el, i in tasks
					model = $(el).data('model')
					console.log model.get('text'), model
					model.save {order: i}, {silent:true} if model?
			stop: (events, ui) =>
				rubbish.hide()



	render: ->
		#@addTasks()

	change: ->
		console.log 'CHANGE'
		@setSelectedContexts contexts.selected()
		display_tasks.sort()
		@addTasks()

	addTasks: ->
		$('#task-list').html ''
		#tasks.filterWithContexts(@selectedContexts).each(@addTask)
		console.log display_tasks
		display_tasks.each @addTask

	addTask: (task) ->
		doneDate = task.get('doneDate')
		if (task.get('done') == false) or (task.get('done') is true and doneDate and doneDate.equals(Date.today()))
			view = new Privydo.Views.Task {model: task}
			$('#task-list').append(view.render().el)
#			console.log "lol:" + task.get('text'), task.get 'order'
		
