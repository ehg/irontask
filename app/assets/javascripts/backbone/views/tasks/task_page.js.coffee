class Privydo.Views.TaskPage extends Backbone.View
	template: JST['backbone/templates/tasks/page']
	el : '#create-task'

	events:
		"keypress #add_task" : "add_on_enter"

	initialize: ->
		@render()
		@input = @$("#add_task")
	
	render: ->
		$(@el).prepend @template
		$('#bin').droppable(
			drop: (event, ui) =>
				
				$(ui.draggable).fadeOut(1000)
				model = $(ui.draggable).data("model")
				$(ui.draggable).remove()
				if model instanceof Privydo.Models.Task
					@collection.remove(model)
					model.destroy()
				if model instanceof Privydo.Models.Context
					if @options.contexts.length > 1
						@options.contexts.remove(model)
						@options.contexts.at(0).save {}
		)


	add_on_enter: (e) ->
		return unless e.keyCode == 13
		[date, text] = @extract_date()
		task = @collection.create @new_attributes(date, text)
		@input.val ''

	new_attributes: (date, text) ->
		text:	text
		done: false
		date: date
		contexts: @contexts_array()

	contexts_array: (contexts) ->
		console.log  @options.contexts.selected()
		_.map @options.contexts.selected(), (c) ->
			c.get('text')


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
		
