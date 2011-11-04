#= require jquery.watermark.min
class IronTask.Views.TaskPage extends Backbone.View
	template: JST['backbone/templates/tasks/page']

	events:
		"keypress #add_task" : "add_on_enter"

	initialize: ->
		@bind 'error', @error
		@render()
	
	error: (model, col) ->#TODO: what's col?
		new IronTask.Views.Error {message: col}

	render: ->
		$(@el).html @template
		@input = @$("#add_task")
		@input.watermark()
		@input.focus()

	add_on_enter: (e) -> #move bulk to model
		return unless e.keyCode == 13
		[date, text] = @extract_date()
		attrs = @new_attributes(date, text)
		delete attrs.date unless date
		task = tasks.create attrs,
			error: @error
		task.new = true
		@input.val ''

	new_attributes: (date, text) -> #move to model
		text:	text
		done: false
		date: date
		contexts: @contexts_array()

	contexts_array: -> #move to model
		_.map contexts.selected(), (c) ->
			c.get 'id'

	extract_date: -> #move to model
		val = @input.val()
		re = new RegExp(".*((for|on) (.*))", "i")
		m = re.exec val
		if m?
			last_match = m[m.length - 1]
			last_match = "next #{last_match}" if last_match.toUpperCase() in ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
			parsedDate = Date.parse last_match
			if parsedDate?
				t = jQuery.trim val.replace(m[1], '')
				[parsedDate, t]
			else
				[null, val]
		else
			[null, val]
		
