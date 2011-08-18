#=require singleclick
class Privydo.Views.Context extends Backbone.View
	template: JST['backbone/templates/tasks/context']
	tagName: 'li'

	taskCollection: null

	events :
		'doubleclick a.context'	: 'edit'
		'singleclick a.context' 		: 'select'
		'keypress input'				: 'update_on_enter'

	initialize: ->
		_.bindAll @, 'render'

	render: ->
		@setContent()
		$(@el).addClass 'selected' if @model.get('selected') == true
		$(@el).attr 'id', "context_#{@model.get 'order'}"
		$(@el).data 'model', @model
		this

	setContent: ->
		$(@el).html @template @options.model.toJSON()
		@$('.context').text @model.get('text')
		@input = @$('input')
		@input.blur @close
		@input.val @model.get 'text'
		@edit() unless @model.get('text')?

	edit: ->
		console.log 'EDIT'
		console.log @model
		$(@el).addClass 'editing'
		@input.focus()

	close: =>
		console.log @model.id
		@model.set {'order' : @maxOrder() + 1 } unless @model.has('order')
		@model.save { text : @input.val() }
		$(@el).removeClass 'editing'

	maxOrder: ->
		(@model.collection.max (c) -> c.get 'order' ).get('order')

	update_on_enter: (e) ->
		@close() if e.keyCode == 13

	select: (e) =>
		if $(@el).is '.selected' #and e.ctrlKey == true
			console.log 'deselect'
			if $('#contexts').find('.selected').length > 1
				@model.save { selected : false }
				@options.taskList.setSelectedContexts @model.collection.selected()
				$(@el).removeClass 'selected'
		else
			@model.collection.selectSingle @model unless e.ctrlKey == true
			@model.save { selected : true }
			@options.taskList.setSelectedContexts @model.collection.selected()
			$(@el).addClass 'selected'

