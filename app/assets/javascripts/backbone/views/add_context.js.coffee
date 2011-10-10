class Privydo.Views.AddContext extends Backbone.View
	events:
		'click #add-context'	:	'addNew'

	addNew: ->
		model = new Privydo.Models.Context {order : @collection.length, text : ''}
		@collection.add model
