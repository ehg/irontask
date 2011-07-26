#= require pidcrypt/aes_cbc
#= require cookies
class Privydo.Models.Task extends Backbone.Model
	defaults:
		'done' 			: false
		'contexts'	:	['Home']
	
	url: ->
		if @get('id') > 0 then "/tasks/#{@get 'id'}" else '/tasks'

	initialize: ->
		#@set {'id' : @guid()} if @isNew?

	validate: (attrs) ->
		if attrs.text?
			return "no text" unless attrs.text.length > 0
		if attrs.done?
			return "no done" unless attrs.done in [true, false]
		if attrs.date?
			return "invalid date" unless attrs.date.getTime and !isNaN attrs.date.getTime() 
	
	@parsal: (res) ->
		plaintext = decrypt(res.content)
		content = $.parseJSON(plaintext)
		{
			id : res.id
			text: content.text
			date: if content.date? then new Date(content.date) else null
			done: res.done
			contexts: content.contexts
		}

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
				'content' : encrypt JSON.stringify(content(model))
				'done' : model.get('done')
			params.data = JSON.stringify(params.data)
		params.processData = false if params.type != "GET"
		response = $.ajax params

	content = (m) ->
		'text' : m.get('text')
		'date' : m.get('date')
		'contexts': m.get('contexts')

	key = ->
		getCookieValue 'key'

	encrypt = (plaintext) ->
		aes = new pidCrypt.AES.CBC()
		aes.encryptText plaintext, key, {nBits: 256}

	decrypt = (ciphertext) ->
		aes = new pidCrypt.AES.CBC()
		aes.decryptText ciphertext, key, {nBits: 256}

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

