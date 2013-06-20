window.contexts = new IronTask.Models.Contexts
window.tasks = new IronTask.Models.Tasks
window.display_tasks = new IronTask.Models.DisplayTasks

$(document).ajaxStart ->
  $('#main').fadeTo 'fast', 0.4
$(document).ajaxStop ->
  $('#main').fadeTo 'fast', 1.0
$.ajaxSetup
  cache: false

class IronTask.Routers.TasksRouter extends Backbone.Router
  routes:
    "" : "index"

  index: ->
    $("#navigation ul li a*").removeClass 'selected'
    $("#navigation ul li a:contains('Home')").addClass 'selected'

    window.contexts_view = new IronTask.Views.Contexts {collection: contexts, el: '#contexts-list'}
    window.add_context_view = new IronTask.Views.AddContext {collection: contexts, el: '#contexts'}
    window.task_list = new IronTask.Views.TaskList {collection: display_tasks, el: '#task-list'}
    
    contexts.bind 'reset', contexts_view.addContexts
    contexts.bind 'change', contexts_view.reorder
    contexts.bind 'add', contexts_view.addContext

    contexts.fetch (success: =>
      task_page =  new IronTask.Views.TaskPage {collection: tasks, contexts: contexts, el: '#create-task'}
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
