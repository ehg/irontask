class Privydo.Views.TaskPage extends Backbone.View
	template: JST['backbone/templates/tasks/page']
	el : '#create-task'

	events:
		"keypress #add_task" : "add_on_enter"

	initialize: ->
		@bind 'error', @error
		@render()
		@input = @$("#add_task")
	
	error: (model, col) ->#TODO: what's col?
		new Privydo.Views.Error {message: col}

	render: ->#TODO: method too big. split up
		$(@el).prepend @template
		$('#bin').droppable(
			tolerance: 'touch'
			drop: (event, ui) =>
				model = $(ui.draggable).data("model")
				if model instanceof Privydo.Models.Task
					model.destroy()
					$(ui.draggable).remove()
				if model instanceof Privydo.Models.Context
					if @options.contexts.length > 1
						tasks_to_del = _(tasks.filterWithContexts [model])
						tasks_to_del.each (t) =>
							task_contexts = t.get('contexts')
							task_contexts =  _.without task_contexts, model.id
							if task_contexts.length == 0
								tasks.remove(t)
								t.destroy()
							else
								t.save { contexts: task_contexts }
						$(ui.draggable).remove()
						contexts.remove(model)
						selected_contexts = _.without( contexts.selected(), model )
						if selected_contexts.length == 0
							base = contexts.at(0)
							base.save {selected: true}
							contexts.selectSingle base
							task_list.setSelectedContexts contexts.selected() #TODO refactoring events will solve this
						else
							base = selected_contexts[0]
							base.save {selected: true}

		)

	add_on_enter: (e) ->
		return unless e.keyCode == 13
		[date, text] = @extract_date()
		attrs = @new_attributes(date, text)
		delete attrs.date unless date
		task = tasks.create attrs,
			error: @error
		@input.val ''

	new_attributes: (date, text) ->
		text:	text
		done: false
		date: date
		contexts: @contexts_array()

	contexts_array: ->
		_.map contexts.selected(), (c) ->
			c.get 'id'

	extract_date: ->
		val = @input.val()
		re = new RegExp(".*(for (.*))", "i")
		m = re.exec val
		if m?
			parsedDate = Date.parse(m[m.length - 1])
			if parsedDate?
				t = jQuery.trim val.replace(m[1], '')
				[parsedDate, t]
			else
				[null, val]
		else
			[null, val]
		
