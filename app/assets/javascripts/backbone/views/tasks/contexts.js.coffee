class Privydo.Views.Contexts extends Backbone.View
	tagName: 'ul'


	initialize: ->
		_.bindAll @, 'addContexts', 'addContext', 'reorder'
		@collection.bind 'select', @selection_changed, @
		rubbish = new Privydo.Views.Rubbish

		$(@el).sortable
			distance: 15
			zIndex: 2000
			appendTo: 'body'
			scroll: false
			update: (event, ui) =>
				cons = @$('#contexts-list').find('li')
				for el, i in cons
					model = $(el).data('model')
					if (contexts.length - 1) != i
						model.set {order: i}, {silent : true}
					else
						model.save {order: i}
			start: (events, ui) =>
				rubbish.render()
			stop: (events, ui) =>
				rubbish.toggleBounce()

	reorder: ->
		@collection.sort()
		@addContexts()

	addContexts: ->
		$(@el).html ''
		@collection.each @addContext

	addContext: (context) ->
		view = new Privydo.Views.Context {model : context}
		$(@el).append view.render().el


	selection_changed: (model) =>
		if $(@el).find('.selected').length > 0
			task_list.setSelectedContexts model.collection.selected()
		else
			model.save {selected: true}
