#=require singleclick
class Privydo.Views.Context extends Backbone.View
	template: JST['backbone/templates/tasks/context']
	tagName: 'li'

	events :
		'doubleclick span.context'	: 'edit'
		'singleclick span.context' 		: 'select'
		'keypress input'				: 'update_on_enter'

	initialize: ->
		_.bindAll @, 'render'

	render: ->
		@setContent()
		$(@el).addClass 'selected' if @model.get('selected') == true
		$(@el).data 'model', @model
		this

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
		, 1

	close: =>
		@model.save { text : @input.val() }
		$(@el).removeClass 'editing'
		if @new
			@model.select()
			@new = false

	update_on_enter: (e) ->
		@close() if e.keyCode == 13

	select: (e) =>
		if $(@el).is('.selected') and (e.ctrlKey == true or e.metaKey == true)
			@model.deselect()
		else
			if e.ctrlKey == true or e.metaKey == true
				@model.select(true)
			else
				@model.select()
			$(@el).addClass 'selected'
		return false
