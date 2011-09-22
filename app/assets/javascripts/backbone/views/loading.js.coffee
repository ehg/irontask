class Privydo.Views.LoadingAnimation extends Backbone.View
	tagName: 'div'
	el: '#loading'

	initialize: ->

	render: ->
		$('#loading').show()
	
	destroy: ->
		$('#loading').fadeOut 'slow'
		#$(@el).remove()
