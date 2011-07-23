class Privydo.Routers.TasksRouter extends Backbone.Router
	routes:
		"" : "index"

	index: ->
		tasks = new Privydo.Models.Tasks
		
		task_page =	new Privydo.Views.TaskPage {collection: tasks}
		list = new Privydo.Views.TaskList {collection: tasks}
		tasks.bind 'add', list.change
		tasks.bind 'reset', list.addTasks
		tasks.bind 'remove', list.change
		tasks.bind 'change', list.change
		tasks.bind 'destroy', list.change
		tasks.fetch()

