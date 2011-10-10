class Privydo.Views.Rubbish extends Backbone.View
	template: JST['backbone/templates/rubbish']
	el: '.rubbish'

	initialize: ->
		$('.rubbish').droppable(
			tolerance: 'touch'
			drop: (event, ui) =>
				model = $(ui.draggable).data("model")
				$(ui.draggable).remove()
				model.destroy()
		)

	render: ->
		$('.rubbish').html @template()
		$('.footer-container').height($('footer-container').height * 2)
		@toggleBounce()
		@
	
	toggleBounce: ->
		mode = if $('.rubbish').is(':hidden') then 'show' else 'hide'
		$('.rubbish').effect "bounce", { times: 2, mode: mode, direction: 'down'}, 300
	
