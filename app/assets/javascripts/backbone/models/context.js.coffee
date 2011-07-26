#=require encryption
class Privydo.Models.Context	extends Backbone.Model
	url: ->
		'/users/' + window.username
	
	defaults:
		'selected' 	: false

	initialize: ->
		console.log getCookieValue('key')
		if @isNew()
			@set {id : @guid()}

	validate: (attrs) ->
		#return "invalid guid" unless or validGuid attrs.id
		#return "invalid text" unless attrs.text? and attrs.text.length > 0
		#return "text too long" unless attrs.text? and attrs.text.length < 10
		#return "no order" unless attrs.order? and _.isNumber attrs.order
		#return "no selection" if attrs.selected? and attrs.selected == null

	validGuid = (guid) ->
		return false unless guid?
		regex = /^(\{{0,1}([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}\}{0,1})$/
		regex.test guid

	guid: ->
		"xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace /[xy]/g, (c) ->
			r = Math.random() * 16 | 0
			v = (if c == "x" then r else (r & 0x3 | 0x8))
			v.toString 16
			
	methodMap =
		create: "POST"
		update: "PUT"
		delete: "PUT"
		read: "GET"

	sync: (method, model, options) ->
		type = methodMap[method]
		params = _.extend(
			type: type
			dataType: "json"
		, options)
		params.url = @url()
		if model and (method == "create" or method == "update" or method == "delete")
			params.contentType = "application/json"
			params.data =
				'metadata' : encrypt JSON.stringify(@generate_contexts()), getCookieValue 'key'
			params.data = JSON.stringify(params.data)
		params.processData = false if params.type != "GET"
		response = $.ajax params

	generate_contexts: ->
		contexts: @collection.toJSON()

class Privydo.Models.Contexts extends Backbone.Collection
	url: ->
		'/users/' + window.username
	
	model: Privydo.Models.Context

	comparator: (context) ->
		context.get 'order'

	parse: (data) ->
		plaintext = decrypt data.metadata, getCookieValue 'key'
		object = $.parseJSON plaintext
		_.map(object.contexts, (c) ->
			{ id : c.id, order : c.order, selected : c.selected, text : c.text }
		)

	selected: ->
		@filter (m) ->
			m.get('text') if m.get('selected') == true 
	
