#= require datejs/date-en-GB
class Privydo.Views.Task extends Backbone.View
	template: JST['backbone/templates/tasks/task']
	tagName: 'li'

	events:
		'dblclick div.task_text'					:	'edit'
		'dblclick div.task_date'					:	'edit'
		'click span.task_date'						:	'edit'
		'keypress input[name=text_input]'	: 'update_on_enter'
		'keypress input[name=date_input]'	: 'update_on_enter'
		'click .tick'											: 'setDone'
		'click .putoff'										: 'putOff'
		'mouseenter'											: 'displayMenu'
		'mouseleave'											: 'hideMenu'

	initialize: ->
		_.bindAll @, 'render'
		@model.bind 'change', @render, @

	render: ->
		$(@el).html(@template(@options.model.toJSON()))
		@input_text = @$('.task_text_input')
		@input_date = @$('.task_date_input')
		$(@el).data 'model', @model
		@setContent()
		@
	
	displayMenu: =>
		@$('.task-menu').stop(false, true).fadeIn(200) unless $(@el).is('.editing_text') or $(@el).is('.editing_date') or $('.ui-draggable-dragging').length > 0 or @model.get('done')

	hideMenu: =>
		@$('.task-menu').stop(false,true).fadeOut(100)

	setContent: ->
		[text, date] = [@model.get('text'), @model.get('date')]
		@$('.task_text').text text
		date_text = @setDisplayDate date
		@input_text.blur @close
		@input_text.val text
		@input_date.blur @close
		@input_date.val date_text
		@display_as_done() if @model.get 'done'
		@$('.putoff').toggle date?
		if @model.new == true
			@$('.task').effect 'pulsate', {times:3}, =>
				@model.new = false

	#not very clean, does too much
	setDisplayDate: (date) ->
		date_text = null
		if date
			date_text = date.toString 'd/M/yyyy'
			$(@el).attr 'class', date.toString 'dMyyyy'
			in_next_week = date.between(Date.today(), Date.today().addDays(7))
			yesterday = date.equals(Date.today().addDays(-1))
			today = date.equals(Date.today())
			tomorrow = date.equals(Date.today().addDays(1))
			overdue = date.compareTo(Date.today()) == -1

			date_text = date.toString('dddd') if in_next_week
			date_text = 'Yesterday' if yesterday
			date_text = 'Today' if today
			date_text = 'Tomorrow' if tomorrow
			
			$(@el).toggleClass('overdue', overdue)
			$(@el).toggleClass('tomorrow', tomorrow)
			$(@el).toggleClass('today', today)

			@$('.task_date').text date_text
		else
			$(@el).attr 'class', 'no-date'
		date_text
	
	display_as_done: ->
		$(@el).addClass 'done-task'
		@$('.task-menu').hide()
		@$('.add_date').hide()
		#need to stop doubleclick events here
	
	edit: (e)->
		srcEl = e.srcElement || e.target
		klass = srcEl.className
		input = @$(".#{klass}_input")
		$(@el).addClass "editing_#{klass}"
		input.focus()
		input.select() if klass.search('date') > -1
		@$('.task-menu').hide()

	close: (e) =>
		srcEl = e.srcElement || e.target
		klass = srcEl.className
		input = @$(".#{klass}")
		if klass.search('date') > -1 then data = {date: Date.parse input.val()} else data = {text: input.val()}
		@model.save data,
			error: (model, response) ->
				new Privydo.Views.Error({message: response.responseText or response})
		$(@el).removeClass "editing_#{klass.replace('_input', '')}"
	
	update_on_enter: (e) ->
		@close(e) if e.keyCode == 13

	putOff: =>
		@model.putOff()

	setDone: =>
		@model.setDone()
		

