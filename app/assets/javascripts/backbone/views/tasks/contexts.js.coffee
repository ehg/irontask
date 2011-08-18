class Privydo.Views.Contexts extends Backbone.View
	tagName: 'ul'
	el: '#contexts'

	events:
		'click img'	:	'addNew'

	initialize: ->
		_.bindAll @, 'addContexts', 'addContext', 'reorder', 'addNew'
		@$('#contexts-list').sortable
			update: (event, ui) =>
				contexts = @$('#contexts-list').find('li')
				for el, i in contexts
					model = $(el).data('model')
					console.log model
					if (contexts.length - 1) != i
						model.set {order: i}, {silent : true}
					else
						model.save {order: i}

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


