class Privydo.Views.Rubbish extends Backbone.View
	template: JST['backbone/templates/rubbish']
	el: '.rubbish'

	initialize: ->
		$('.rubbish').droppable(
			tolerance: 'touch'
			drop: (event, ui) =>
				model = $(ui.draggable).data("model")
				if model instanceof Privydo.Models.Task
					model.destroy()
					$(ui.draggable).remove()
				if model instanceof Privydo.Models.Context
					if contexts.length > 1
						tasks_to_del = _(tasks.filterWithContexts [model])
						tasks_to_del.each (t) =>
							task_contexts = t.get('contexts')
							task_contexts =  _.without task_contexts, model.id
							if task_contexts.length == 0
								tasks.remove(t)
								t.destroy()
							else
								t.save { contexts: task_contexts }
						$(ui.draggable).remove()
						selected_contexts = _.without( contexts.selected(), model )
						if selected_contexts.length == 0
							base = contexts.at(0)
							base.save {selected: true}
							contexts.selectSingle base
							task_list.setSelectedContexts contexts.selected() #TODO refactoring events will solve this
						else
							base = selected_contexts[0]
							base.save {selected: true}

						contexts.remove(model)
		)


	render: ->
		$('.rubbish').html @template()
		$('.footer-container').height($('footer-container').height * 2)
		$('.rubbish').effect "bounce", { times: 2, mode: 'show', direction: 'down'}, 300
		@
	
	hide: ->
		$('.rubbish').effect "bounce", { times: 2, mode: 'hide', direction: 'down'}, 300
	

