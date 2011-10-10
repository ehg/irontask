#= require jquery.dotimeout
class Privydo.Views.Notice extends Backbone.View
	className: "success"
	displayLength: 5000
	defaultMessage: ''
	el: '#notice-bar'

	initialize: ->
		_.bindAll this, 'render'
		@display = @options.message || @defaultMessage
		try
			@display = @parseErrors(@display)
		@render()

	render: ->
		$(@el).addClass @className
		$(@el).html(@display)
		$(@el).hide()
		$(@el).slideDown()
		jQuery.doTimeout @displayLength, =>
			$(@el).slideUp()
		@

	parseErrors: (json) ->
		display = "<ul class='notice-list'>"
		for field, errorText of jQuery.parseJSON(json)
			display += "<li>#{errorText}</li>"
		@displayLength = @displayLength * 2
		display + '</ul>'


class Privydo.Views.Error extends Privydo.Views.Notice
	className: "error"
	defaultMessage: "Shit. It's all gone wrong :("
