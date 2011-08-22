#=require datejs/date-en-GB
class Privydo.Views.TaskList extends Backbone.View
	tagName: 'ul'
	className: 'tasks'
	el: '#app'

	selectedContexts: []

	setSelectedContexts: (contexts) ->
		@selectedContexts = contexts
		@addTasks()

	initialize: ->
		_.bindAll(this, 'render', 'addTasks', 'addTask', 'change')
		$('#task-list').sortable {}
			start: (event, ui) =>
				klass = $(ui.item).attr 'class'
				console.log klass
				$('#task-list').sortable('option', 'items', ".#{klass}")
				$('#task-list').sortable('refresh')
			update: (event, ui) =>
				tasks = @$('li')
				for el, i in tasks
					model = $(el).data('model')
					console.log model.get('text'), model
					model.save {order: i}, {silent:true} if model?


	render: ->
		#@addTasks()

	change: ->
		@collection.sort()
		@addTasks()

	addTasks: ->
		$('#task-list').html ''
		@collection.filterWithContexts(@selectedContexts).each(@addTask)

	addTask: (task) ->
		doneDate = task.get('doneDate')
		if (task.get('done') == false) or (task.get('done') is true and doneDate and doneDate.equals(Date.today()))
			view = new Privydo.Views.Task {model: task}
			$('#task-list').append(view.render().el)
