class Privydo.Routers.TasksRouter extends Backbone.Router
	routes:
		"" : "index"

	index: ->
		tasks = new Privydo.Models.Tasks
		contexts = new Privydo.Models.Contexts

		list = new Privydo.Views.TaskList {collection: tasks}
		contexts_view = new Privydo.Views.Contexts {collection: contexts, taskList: list}
		contexts.bind 'reset', contexts_view.addContexts
		contexts.bind 'change', contexts_view.reorder
		contexts.bind 'add', contexts_view.addContexts
		contexts.fetch (success: =>
		
			task_page =	new Privydo.Views.TaskPage {collection: tasks, contexts: contexts}
			list.setSelectedContexts contexts.selected()
			tasks.bind 'add', list.change
			tasks.bind 'reset', list.addTasks
			tasks.bind 'remove', list.change
			tasks.bind 'change', list.change
			tasks.bind 'destroy', list.change
			tasks.fetch()
		)
