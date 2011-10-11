#=require encryption
#=require guid
class Privydo.Models.Context	extends Backbone.Model
	url: ->
		'/users/' + window.username

	collection: window.contexts

	defaults:
		'selected' 	: false

	initialize: ->
		if @isNew()
			@set {id : Privydo.Guid.new()}

	validate: (attrs) ->
		return "invalid guid" if 'id' of attrs and !Privydo.Guid.is_valid(attrs.id)
		return "invalid text" if 'text' of attrs and attrs.text.length < 1
		return "text too long" if 'text' of attrs and attrs.text.length > 18
		return "no order" if 'order' of attrs and !_.isNumber(attrs.order)
		return "no selection" if 'selected' of attrs and attrs.selected == null

	sync: (method, model, options) ->
		if method == "create" or method == "update" or method == "delete"
			options.contentType = 'application/json'
			options.data =
				'metadata' : JSON.stringify(@generate_contexts())#encrypt JSON.stringify(@generate_contexts()), getCookieValue 'key'
			options.data = JSON.stringify options.data
		Backbone.sync method, model, options

	generate_contexts: ->
		contexts: @collection.toJSON()
	
	select: (multiple = false) ->
		@collection.selectSingle @ unless multiple == true
		@save { selected : true }
		@trigger 'select', @
	
	deselect: ->
		@save { selected: false }
		@trigger 'select', @
	
	destroy: ->
		if contexts.length > 1
			tasks_to_del = _(tasks.filterWithContexts [@])
			tasks_to_del.each (t) =>
				task_contexts = t.get('contexts')
				task_contexts =  _.without task_contexts, @id
				if task_contexts.length == 0
					tasks.remove(t)
					t.destroy()
				else
					t.save { contexts: task_contexts }
			@collection.remove @

class Privydo.Models.Contexts extends Backbone.Collection
	model: Privydo.Models.Context
	url: ->
		'/users/' + window.username
	
	initialize: ->
		@bind 'remove', @context_removed, @

	comparator: (context) ->
		context.get 'order'

	parse: (data) ->
		plaintext = data.metadata#decrypt data.metadata, getCookieValue 'key'
		object = $.parseJSON plaintext
		_.map(object.contexts, (c) ->
			{ id : c.id, order : c.order, selected : c.selected, text : c.text }
		)

	selectSingle: (context) ->
		@each (c) ->
			c.set {'selected' : c.id == context.id}

	selected: ->
		@filter (m) ->
			m.get('text') if m.get('selected') == true
	
	context_removed: (model, collection) ->
		model.sync('update', model, {})
		selected = _.without( @selected(), model )
		if !selected or selected.length == 0 then @at(0).select()
