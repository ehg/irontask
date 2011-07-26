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

	render: ->
		#@addTasks()

	change: ->
		@collection.sort()
		@addTasks()

	addTasks: ->
		$('#task-list').html ''
		@collection.filterWithContexts(@selectedContexts).each(@addTask)

	addTask: (task) ->
		view = new Privydo.Views.Task {model: task}
		$('#task-list').append(view.render().el)
