class IronTask.Views.AddContext extends Backbone.View
	events:
		'click #add-context'	:	'addNew'

	addNew: ->
		model = new IronTask.Models.Context {order : @collection.length, text : ''}
		@collection.add model
