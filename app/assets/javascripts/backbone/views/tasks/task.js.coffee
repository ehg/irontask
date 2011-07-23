class Privydo.Views.Task extends Backbone.View
	template: JST['backbone/templates/tasks/task']
	tagName: 'li'	
	dragging: false

	events:
		'dblclick div.task_text'		:	'edit_text'
		'dblclick div.task_date'		:	'edit_date'
		'keypress .task-text-input'	: 'update_on_enter_text'
		'keypress .task-date-input'	: 'update_on_enter_date'
		'click .tick'								: 'setDone'
		'click .putoff'							: 'putOff'

	initialize: ->
		_.bindAll @, 'render'
		@model.bind 'change', @render
		$(@el).hover =>
			@$('.task-menu').stop(false, true).fadeIn(200) unless $(@el).is('.editing_text') or $(@el).is('.editing_date') or @dragging
		, =>
			@$('.task-menu').stop(false,true).fadeOut(100)
		

	render: ->
		$(@el).html(@template(@options.model.toJSON()))
		$(@el).find('.task_text').draggable({ revert : true},
			start: =>
				@draggging = true
			stop: =>
				@dragging = false
		).data("model", @model)
		@setContent()
		this


	putOff: =>
		oldDate = @model.get('date')
		if oldDate
			newDate = oldDate.add(1).days()
			@model.save { date : newDate }
			@model.change()

	setDone: =>
		@model.save { done : true }
		console.log @model
		@model.collection.remove @model

	setContent: ->
		[text, date] = [@model.get('text'), @model.get('date')]
		@$('.task_text').text text
		date_text = null
		if date
			date_text = date.toString('d/M/yyyy')
			@$('.task_date').text date_text
		@input_text = @$('.task-text-input')
		@input_text.blur @close_text
		@input_text.val text

		@input_date = @$('.task-date-input')
		@input_date.blur @close_date
		@input_date.val date_text


	edit_text: ->
		console.log 'edit text'
		$(@el).addClass 'editing_text'
		@$('.task-menu').hide()
		@input_text.focus()

	edit_date: ->
		@$('.task-menu').hide()
		$(@el).addClass 'editing_date'
		@input_date.focus()

	close_text: =>
		console.log @model.save {text: @input_text.val()},
			error: (model, response) ->
				new Privydo.Views.Error({message: response.responseText or response})
		$(@el).removeClass 'editing_text'
	
	close_date: =>
		@model.save {date: Date.parse(@input_date.val())},
			error: (model, response) ->
				new Privydo.Views.Error({message: response.responseText or response})
		$(@el).removeClass 'editing_date'
	
	update_on_enter_text: (e) ->
		@close_text() if e.keyCode == 13

	update_on_enter_date: (e) ->
		@close_date() if e.keyCode == 13

