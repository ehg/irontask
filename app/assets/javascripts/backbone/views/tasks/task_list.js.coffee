#=require datejs/date-en-GB
class Privydo.Views.TaskList extends Backbone.View
	tagName: 'ul'

	initialize: ->
		_.bindAll this, 'render', 'addTasks', 'addTask', 'change'
		@setSortable()

	change: ->
		@setSelectedContexts contexts.selected()
		@collection.sort()
		@addTasks()

	addTasks: ->
		if @collection.length > 0
			$(@el).html ''
			@collection.each @addTask
		else
			$(@el).html "<span id='task-placeholder'>You haven't got anything to do!</span>"
		@

	addTask: (task) ->
		doneDate = task.get 'doneDate'
		if (task.get('done') == false) or (task.get('done') is true and doneDate and doneDate.equals(Date.today()))#move into model
			view = new Privydo.Views.Task {model: task}
			$(@el).append view.render().el
		
	setSelectedContexts: (contexts) -># how can we test this? coupled? move to collection
		@collection.reset tasks.filterWithContexts(contexts)
		@addTasks()

	setSortable: ->
		rubbish = new Privydo.Views.Rubbish
		$(@el).sortable {}
			scroll: false
			start: (event, ui) =>
				@setSortableItems ui
				rubbish.render()
			update: (event, ui) =>
				@saveSortOrder()
			stop: (events, ui) =>
				$(@el).sortable 'option', 'items', "li"
				$(@el).sortable 'refresh'
				rubbish.toggleBounce()

	setSortableItems: (ui) ->
		klass = $(ui.item).attr('class').split(' ')[0]
		$(@el).sortable 'option', 'items', ".#{klass}"
		$(@el).sortable 'refresh'
	
	saveSortOrder: ->
		tasks = @$('li')
		for el, i in tasks
			model = $(el).data('model')
			model.save {order: i}, {silent:true} if model
