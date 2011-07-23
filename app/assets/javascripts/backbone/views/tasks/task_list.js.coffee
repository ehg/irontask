#=require datejs/date-en-GB
class Privydo.Views.TaskList extends Backbone.View
	tagName: 'ul'
	className: 'tasks'
	el: '#app'
	
	initialize: ->
		_.bindAll(this, 'render', 'addTasks', 'addTask', 'change')

	render: ->
		#@addTasks()

	change: ->
		console.log 'change received'
		@collection.sort()
		@addTasks()

	addTasks: ->
		$('#task-list').html ''
		@collection.each(@addTask)

	addTask: (task) ->
		view = new Privydo.Views.Task {model: task}
		$('#task-list').append(view.render().el)
