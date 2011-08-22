#=require singleclick
class Privydo.Views.Context extends Backbone.View
	template: JST['backbone/templates/tasks/context']
	tagName: 'li'

	taskCollection: null

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
		@$('.context').text @model.get('text')
		@input = @$('input')
		@input.blur @close
		@input.val @model.get 'text'
		(@edit() && @new = true) if @model.get('text') == ''

	edit: ->
		$(@el).addClass 'editing'
		@input.focus()

	close: =>
		@model.save { text : @input.val() }
		$(@el).removeClass 'editing'
		if @new
			@model.save {selected : true}
			@model.collection.selectSingle @model
			@options.taskList.setSelectedContexts @model.collection.selected()
			@new = false

	update_on_enter: (e) ->
		@close() if e.keyCode == 13

	select: (e) =>
		if $(@el).is('.selected') and e.ctrlKey == true
			console.log 'selected'
			if $('#contexts').find('.selected').length > 1
				console.log 'nooo'
				@model.save { selected : false }
				@options.taskList.setSelectedContexts @model.collection.selected()
				$(@el).removeClass 'selected'
		else
			@model.collection.selectSingle @model unless e.ctrlKey == true
			@model.save { selected : true }
			@options.taskList.setSelectedContexts @model.collection.selected()
			$(@el).addClass 'selected'
		return false
