#= require encryption

describe "Context model", ->
	beforeEach ->
		@context = new Privydo.Models.Context
		@eventSpy = sinon.spy()
		@context.bind 'error', @eventSpy
	
	contextAttributes = ->
		id : 'de3a5123-8a8c-46b4-b655-d2a943070c1c'
		text : 'Home'
		order : 0
		selected : false


	it "should be valid with valid attributes", ->
		@context.set contextAttributes()
		expect(@eventSpy.called).toBeFalsy()

	it "should not be valid without a valid guid", ->
		attr = contextAttributes()
		attr.id = "dfsdfsdfsdf"
		@context.set attr
		expect(@eventSpy).toHaveBeenCalledOnce()

	it "should not be valid without text", ->
		attr = contextAttributes()
		attr.text = ""
		@context.set attr
		expect(@eventSpy).toHaveBeenCalledOnce()
	
	it "should not be valid if the text too long", ->
		attr = contextAttributes()
		attr.text = "THIS IS FAR TOO LONG"
		@context.set attr
		expect(@eventSpy).toHaveBeenCalledOnce()

	it "should not be valid without an order", ->
		attr = contextAttributes()
		attr.order = null
		@context.set attr
		expect(@eventSpy).toHaveBeenCalledOnce()

	it "should not be valid if selected isn't specified", ->
		attr = contextAttributes()
		attr.selected = null
		@context.set attr
		expect(@eventSpy).toHaveBeenCalledOnce()

	it "should initialise with a random guid id", ->
		context = new Privydo.Models.Context { text : 'text', order : 0, selected : false }
		expect(context.id).toBeDefined()

	it "should save the whole collections object to the server", ->
		# TODO: test we're saving encrypted collection?
		@contexts = new Privydo.Models.Contexts
		@contexts.add new Privydo.Models.Context { text : 'At the G', order : 3, selected : false }
		@contexts.add new Privydo.Models.Context { text : 'Biscuit', order : 0, selected : false }
		@contexts.add new Privydo.Models.Context { text : 'Egg', order : 1, selected : false }
		@contexts.add new Privydo.Models.Context { text : 'Ham', order : 2, selected : true }
		@contexts.add @context

		@context.save { text : 'At the G', order : 3, selected : false }
		expect(@eventSpy.called).toBeFalsy()

describe "Context collection", ->
	beforeEach ->
		@contexts = new Privydo.Models.Contexts
		@c1 = new Privydo.Models.Context { text : 'At the Gates', order : 3, selected : false }
		@c2 = new Privydo.Models.Context { text : 'Biscuit', order : 0, selected : false }
		@c3 = new Privydo.Models.Context { text : 'Egg', order : 1, selected : true }
		@c4 = new Privydo.Models.Context { text : 'Ham', order : 2, selected : true }

	describe "Ordering", ->
		it "should order the models by order", ->
			@contexts.add [@c1, @c2, @c3, @c4]
			expect(@contexts.at 0).toBe @c2
			expect(@contexts.at 1).toBe @c3
			expect(@contexts.at 2).toBe @c4
			expect(@contexts.at 3).toBe @c1
	
	describe "Operations", ->
		beforeEach ->
			@contexts.add [@c1, @c2, @c3, @c4]

		it "selects a single context (deselecting the other ones)", ->
			@contexts.selectSingle @c2
			expect(@c1.get('selected')).toBeFalsy()
			expect(@c2.get('selected')).toBeTruthy()
			expect(@c3.get('selected')).toBeFalsy()
			expect(@c4.get('selected')).toBeFalsy()

		it "returns a list of selected contexts", ->
			selected = @contexts.selected()
			expect(selected.length).toEqual 2

		describe "When a context has been removed", ->
			beforeEach ->
				@spy = sinon.spy @c1, "sync"

			it "calls sync on the model", ->
				@contexts.remove @c1
				expect(@spy).toHaveBeenCalledOnce()
				expect(@spy).toHaveBeenCalledWith 'update', @c1

			it "selects the first context if there are no other contexts selected", ->
				@contexts.selectSingle @c1
				@contexts.remove @c1
				expect(@contexts.selected()[0]).toBe @c2

			it "leaves the selections as they are if there are any other contexts selected", ->
				@contexts.remove @c3
				expect(@contexts.selected()[0]).toBe @c4
						

#	describe "Server", ->
#		beforeEach ->
#			window.username = 'chris'
#			writeSessionCookie 'key', 'secret'
#			@server = sinon.fakeServer.create()
#			@server.respondWith 'GET', '/users/chris', @validResponse @fixtures.MetaData.valid
#			@contexts = new Privydo.Models.Contexts
#
#		afterEach ->
#			@server.restore()
#			deleteCookie 'key'
#
#		it "should make the correct request", ->
#			@contexts.fetch()
#			expect(@server.requests.length).toEqual(1)
#			expect(@server.requests[0].method).toEqual 'GET'
#			expect(@server.requests[0].url).toEqual '/users/chris'
#
#		it "should parse the context from the encrypted metadata", ->
#			@contexts.fetch()
#			@server.respond()
#			expect(@contexts.length).toEqual 2
#			expect(@contexts.at(0).get('text')).toEqual 'Home'
#
#		
