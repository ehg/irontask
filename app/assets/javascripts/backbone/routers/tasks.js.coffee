window.contexts = new Privydo.Models.Contexts
window.tasks = new Privydo.Models.Tasks
window.display_tasks = new Privydo.Models.DisplayTasks

window.loading_anim = new Privydo.Views.LoadingAnimation
$(document).ajaxStart ->
	$('#main').fadeTo 'fast', 0.4
$(document).ajaxStop ->
	$('#main').fadeTo 'fast', 1.0

class Privydo.Routers.TasksRouter extends Backbone.Router
	routes:
		"" : "index"

	index: ->
		$("#navigation ul li a*").removeClass 'selected'
		$("#navigation ul li a:contains('Home')").addClass 'selected'

		window.contexts_view = new Privydo.Views.Contexts
		window.task_list = new Privydo.Views.TaskList
		
		contexts.bind 'reset', contexts_view.addContexts
		contexts.bind 'change', contexts_view.reorder
		contexts.bind 'add', contexts_view.addContext

		contexts.fetch (success: =>
			task_page =	new Privydo.Views.TaskPage {collection: tasks, contexts: contexts}
			tasks.bind 'add', task_list.change
			tasks.bind 'reset', task_list.addTasks
			tasks.bind 'remove', task_list.change
			tasks.bind 'change:text', task_list.change
			tasks.bind 'change:date', task_list.change
			tasks.bind 'destroy', task_list.change
			tasks.fetch(success: =>
				task_list.setSelectedContexts contexts.selected()
			)
		)
