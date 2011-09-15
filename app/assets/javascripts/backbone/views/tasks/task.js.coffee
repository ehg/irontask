#= require datejs/date-en-GB
class Privydo.Views.Task extends Backbone.View
	template: JST['backbone/templates/tasks/task']
	tagName: 'li'

	events:
		'dblclick div.task_text'		:	'edit_text'
		'dblclick div.task_date'		:	'edit_date'
		'click span.add_date'				:	'edit_date'
		'keypress .task-text-input'	: 'update_on_enter_text'
		'keypress .task-date-input'	: 'update_on_enter_date'
		'click .tick'								: 'setDone'
		'click .putoff'							: 'putOff'

	initialize: ->
		_.bindAll @, 'render', 'set_done'
		@model.bind 'change', @render
		@model.bind 'change:done', @set_done

		$(@el).hover =>
			@$('.task-menu').stop(false, true).fadeIn(200) unless $(@el).is('.editing_text') or $(@el).is('.editing_date') or $('.ui-draggable-dragging').length > 0 or @model.get('done')
		, =>
			@$('.task-menu').stop(false,true).fadeOut(100)

	render: ->
		$(@el).html(@template(@options.model.toJSON()))
		$(@el).data 'model', @model
		@setContent()
		this


	putOff: =>
		oldDate = @model.get('date')
		if oldDate
			yesterday = Date.today().addDays(-1)
			oldDate = yesterday if oldDate.compareTo(yesterday) == -1
			newDate = oldDate.add(1).days()
			@model.save { date : newDate }
			@model.change()

	setDone: =>
		@model.save { done : true, doneDate : Date.today() }
		console.log @model
		#@model.collection.remove @model

	setContent: ->
		[text, date] = [@model.get('text'), @model.get('date')]
		@$('.task_text').text text
		date_text = null
		if date
			date_text = date.toString('d/M/yyyy')
			date_text = date.toString('dddd') if date.between(Date.today(), Date.today().addDays(7))
			date_text = 'Yesterday' if date.equals(Date.today().addDays(-1))
			(date_text = 'Today') && $(@el).addClass 'today' if date.equals(Date.today())
			date_text = 'Tomorrow' if date.equals(Date.today().addDays(1))
			@$('.task_date').text date_text

			$(@el).addClass 'overdue' if date.compareTo(Date.today()) == -1
		else
			$(@el).addClass 'no-date'

		@input_text = @$('.task-text-input')
		@input_text.blur @close_text
		@input_text.val text

		@input_date = @$('.task-date-input')
		@input_date.blur @close_date
		@input_date.val date_text

		@set_done() if @model.get 'done'

	set_done: ->
		$(@el).addClass 'done-task'
		@$('.task-menu').hide()
		@$('.add_date').hide()
	
	edit_text: ->
		$(@el).addClass 'editing_text'
		@$('.task-menu').hide()
		@input_text.focus()

	edit_date: ->
		@$('.task-menu').hide()
		$(@el).addClass 'editing_date'
		@input_date.focus()

	close_text: =>
		@model.save {text: @input_text.val()},
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

