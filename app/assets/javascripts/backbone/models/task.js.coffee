#= require pidcrypt/aes_cbc
#= require cookies
class Privydo.Models.Task extends Backbone.Model
	defaults:
		'done' 			: false
		'order'			: -1
	
	url: ->
		if @get('id') > 0 then "/tasks/#{@get 'id'}" else '/tasks'

	validate: (attrs) ->
		return "no text" if 'text' of attrs and attrs.text and attrs.text.length < 1
		return "text too long" if 'text' of attrs and attrs.text and attrs.text.length > 60
		return "no done" if 'done' of attrs and !(attrs.done in [true, false])
		return "invalid date" if 'date' of attrs and !_.isDate(attrs.date)
		return "no contexts specified" if 'contexts' of attrs and (!_.isArray(attrs.contexts) or attrs.contexts.length < 1)
	
	@parsal: (res) ->
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

	guid: ->
		"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
			r = Math.random() * 16 | 0
			v = (if c == "x" then r else (r & 0x3 | 0x8))
			v.toString 16

	parse: (res) ->
		if res.id then return { id : res.id }
		Privydo.Models.Task.parsal(res)

	methodMap =
		create: "POST"
		update: "PUT"
		delete: "DELETE"
		read: "GET"

	sync: (method, model, options) ->
		type = methodMap[method]
		params = _.extend(
			type: type
			dataType: "json"
		, options)
		params.url = getUrl(model) or urlError()  unless params.url
		if not params.data and model and (method == "create" or method == "update")
			params.contentType = "application/json"
			params.data =
				'content' : JSON.stringify(content(model)) #encrypt JSON.stringify(content(model)), getCookieValue 'key'
				'done' : model.get('done')
			params.data = JSON.stringify(params.data)
		params.processData = false if params.type != "GET"
		$.ajax params

	content = (m) ->
		'text' : m.get('text')
		'date' : m.get('date')
		'doneDate' : m.get('doneDate')
		'order' : m.get 'order'
		'contexts': m.get('contexts')

	getUrl = (object) ->
		return null  unless (object and object.url)
		(if _.isFunction(object.url) then object.url() else object.url)

	urlError = ->
		throw new Error("A \"url\" property or function must be specified")

class Privydo.Models.Tasks extends Backbone.Collection
	model: Privydo.Models.Task
	url: '/tasks'
	
	parse: (res) ->
		_.map(res, (o) ->
			Privydo.Models.Task.parsal(o)
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
		heh = "#{date_order}|#{task.get('text').toUpperCase()}"
		heh

