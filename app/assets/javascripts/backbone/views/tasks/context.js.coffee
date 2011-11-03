#=require singleclick
class Privydo.Views.Context extends Backbone.View
	template: JST['backbone/templates/tasks/context']
	tagName: 'li'

	events :
		'doubleclick span.context'	: 'edit'
		'singleclick span.context' 		: 'select'
		'keyup input'				: 'update_on_enter'

	initialize: ->
		_.bindAll @, 'render'
		@model.bind 'change:selected', @selection_changed, @

	render: ->
		@setContent()
		$(@el).addClass 'selected' if @model.get('selected') == true
		$(@el).data 'model', @model
		$(@el).droppable(
			accept: '#task-list li'
			tolerance: 'pointer'
			hoverClass: 'highlight'
			drop: (e, ui) =>
				models = []
				for draggable, i in ui.helper
					models.push  $($(ui.helper)[i]).data('model')
				_.each models, (model) => model.moveTo(@model.id) if model instanceof Privydo.Models.Task
				$(ui.helper).remove()
		)
		@

	setContent: ->
		$(@el).html @template @options.model.toJSON()
		@input = @$('input')
		(@edit() && @new = true) if @model.get('text') == ''
		@$('.context').text @model.get('text')
		@input.blur @close
		@input.val @model.get 'text'

	edit: =>
		$(@el).addClass 'editing'
		setTimeout =>
			@input.focus()
		, 0

	close: =>
		@model.save { text : @input.val() },
			error: (m, res) =>
				new Privydo.Views.Error {message: res.responseText or res}
			success: =>
				$(@el).removeClass 'editing'
				if @new
					@model.select()
					@new = false

	update_on_enter: (e) ->
		@new && @model.destroy() && @remove() if e.keyCode == 27
		@close() if e.keyCode == 13

	select: (e) =>
		if $(@el).is('.selected') and (e.ctrlKey == true or e.metaKey == true)
			@model.deselect()
		else
			if e.ctrlKey == true or e.metaKey == true
				@model.select(true)
			else
				@model.select()
		return false

	selection_changed: ->
		$(@el).toggleClass 'selected', @model.get 'selected'
