#= require pidcrypt/aes_cbc
#= require cookies
class Privydo.Models.Task extends Backbone.Model
	defaults:
		'done' 			: false
		'contexts'	:	['Home']
	
	url: ->
		if @get('id') > 0 then "/tasks/#{@get 'id'}" else '/tasks'

	validate: (attrs) ->
		return "no text" if 'text' of attrs and attrs.text and attrs.text.length < 1
		return "text too long" if 'text' of attrs and attrs.text and attrs.text.length > 60
		return "no done" if 'done' of attrs and !(attrs.done in [true, false])
		return "invalid date" if 'date' of attrs and !_.isDate(attrs.date)
		return "no contexts specified" if 'contexts' of attrs and (!_.isArray(attrs.contexts) or attrs.contexts.length < 1)
	
	@parsal: (res) ->
		console.log res
		plaintext = decrypt res.content, getCookieValue 'key'
		console.log plaintext
		content = $.parseJSON(plaintext)
		return if content is null
		object =
			id : res.id
			text: content.text
			date: if content.date? then new Date(content.date) else null
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
				'content' : encrypt JSON.stringify(content(model)), getCookieValue 'key'
				'done' : model.get('done')
			params.data = JSON.stringify(params.data)
		params.processData = false if params.type != "GET"
		$.ajax params

	content = (m) ->
		'text' : m.get('text')
		'date' : m.get('date')
		'contexts': m.get('contexts')

	getUrl = (object) ->
		return null  unless (object and object.url)
		(if _.isFunction(object.url) then object.url() else object.url)

	urlError = ->
		throw new Error("A \"url\" property or function must be specified")

class Privydo.Models.Tasks extends Backbone.Collection
	model: Privydo.Models.Task
	url: '/tasks'

	comparator: (task) ->
		date = task.get('date')
		return date if date
		new Date(2999, 5, 25)	

	parse: (res) ->
		_.map(res, (o) ->
			Privydo.Models.Task.parsal(o)
		)

	filterWithContexts: (contexts) ->
		ids = _.map contexts, (c) ->
			c.get('text')
		_(@models.filter (t) ->
			#_.isEqual t.get('contexts').sort(), ids.sort()
			_.intersect(t.get('contexts'), ids).length > 0
		)

