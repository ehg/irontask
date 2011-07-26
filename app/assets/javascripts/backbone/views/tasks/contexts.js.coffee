class Privydo.Views.Contexts extends Backbone.View
	tagName: 'ul'
	el: '#contexts'

	events:
		'click img'	:	'addNew'

	initialize: ->
		_.bindAll @, 'addContexts', 'addContext', 'reorder', 'addNew'

	render: ->

	reorder: ->
		@collection.sort()
		@addContexts()

	addContexts: ->
		@$('#contexts-list').html ''
		@collection.each @addContext

	addContext: (context) ->
		view = new Privydo.Views.Context {model : context, taskList: @options.taskList}
		@$('#contexts-list').append view.render().el

	addNew: ->
		model = new Privydo.Models.Context 
		@collection.add model


