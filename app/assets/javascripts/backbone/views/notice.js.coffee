#= require jquery.dotimeout
class Privydo.Views.Notice extends Backbone.View
	className: "success"
	displayLength: 5000
	defaultMessage: ''

	initialize: ->
		_.bindAll this, 'render'
		@display = @options.message || @defaultMessage
		try
			@display = @parseErrors(@display)
		@render()

	render: ->
		view = this
		$(this.el).html(@display)
		$(this.el).hide()
		$('#notice').html(this.el)
		$(this.el).slideDown()
		jQuery.doTimeout(@displayLength, (->	jQuery(view.el).slideUp(); jQuery.doTimeout(2000, ( -> view.remove() ))))
		return this

	parseErrors: (json) ->
		display = '' 
		for field, errorText of jQuery.parseJSON(json)
			display += "<li>#{field} #{errorText}</li>"
		display


class Privydo.Views.Error extends Privydo.Views.Notice
	className: "error"
	defaultMessage: "Shit. It's all gone wrong :("
