#= require pidcrypt/aes_cbc
#= require cookies
class Privydo.Models.Task extends Backbone.Model
	defaults:
		'done' 			: false
		'order'			: -1
	
	url: ->
		if @get('id') > 0 then "/tasks/#{@get 'id'}" else '/tasks'

	validate: (attrs) ->
		return "no text" if 'text' of attrs and attrs.text.length < 1
		return "text too long" if 'text' of attrs and attrs.text and attrs.text.length > 60
		return "no done" if 'done' of attrs and !(attrs.done in [true, false])
		return "invalid date" if 'date' of attrs and (!_.isDate(attrs.date) and attrs.date != null)
		return "no contexts specified" if 'contexts' of attrs and (!_.isArray(attrs.contexts) or attrs.contexts.length < 1)
	
	@parse: (res) ->
		plaintext = res.content#decrypt res.content, getCookieValue 'key'
		content = $.parseJSON(plaintext)
		return if content is null
		object =
			id : res.id
			text: content.text
			date: if content.date? then new Date(content.date) else null
			doneDate: if content.doneDate? then new Date(content.doneDate) else null
			order: content.order || -1
			done: res.done
			contexts: content.contexts
		delete object.date if object.date is null
		object

	parse: (res) ->
		if res.id then return { id : res.id }
		Privydo.Models.Task.parse(res)

	sync: (method, model, options) ->
		if method == "create" or method == "update"
			data =
				'content' : JSON.stringify content(model)
				'done' : model.get 'done'
			options.data = JSON.stringify data
			options.contentType = 'application/json'
		Backbone.sync method, model, options

	content = (m) ->
		'text' : m.get 'text'
		'date' : m.get 'date'
		'doneDate' : m.get 'doneDate'
		'order' : m.get 'order'
		'contexts': m.get 'contexts'
	
	putOff: ->
		oldDate = @get('date')
		if oldDate
			yesterday = Date.today().addDays(-1)
			oldDate = yesterday if oldDate.compareTo(yesterday) == -1
			newDate = oldDate.add(1).days()
			@save { date : newDate }
			@change()
	
	setDone: ->
		@save { done : true, doneDate : Date.today() }

	destroy: ->
		window.tasks.remove @
		super
	
class Privydo.Models.Tasks extends Backbone.Collection
	model: Privydo.Models.Task
	url: '/tasks'
	
	parse: (res) ->
		_.map(res, (o) ->
			Privydo.Models.Task.parse(o)
		)

	done: ->
		@filter (task) -> task.get 'done' is true

	notdone: ->
		@filter (task) -> task.get 'done' is false

	filterWithContexts: (contexts) ->
		ids = _.map contexts, (c) ->
			c.get('id')
		@models.filter (t) ->
			_.intersect(t.get('contexts'), ids).length > 0
		
class Privydo.Models.DisplayTasks extends Privydo.Models.Tasks
	comparator: (task) ->
		date = task.get('date') || new Date(2998,5,1)
		order = task.get('order') || 0
		date_order = date.getTime() + order
		"#{date_order}|#{task.get('text').toUpperCase()}"

