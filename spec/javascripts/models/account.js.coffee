describe "Account", ->
	beforeEach ->
		@account = new Privydo.Models.Account ( {username : 'test', password : 'testing'} )
		@eventSpy = sinon.spy()
		@account.bind("error", @eventSpy)

	describe "When AJAX is stubbed", ->
		beforeEach ->
			@stub = sinon.stub jQuery, "ajax"
			
		afterEach ->
			jQuery.ajax.restore()

		it "should exhibit attributes", ->
			expect(@account.get('username')).toEqual('test')
	
		it "should make a new account", ->
			@account.save()
			expect(@stub).toHaveBeenCalled()
	
		it "should SHA256 the password", ->
			hash = @account.hash 'testing'
			expect(hash).toNotBe(null)
			expect(hash).toNotEqual('testing')
	
		it "should display an error if the username is empty", ->
			@account.save({ username : '', password : 'testing' })
			expect(@eventSpy.calledOnce).toBeTruthy()
			expect(@eventSpy.calledWith(@account, "username empty")).toBeTruthy()
	
		it "should display an error if the password is empty", ->
			@account.save({ username : 'test', password : '' })
			expect(@eventSpy.calledOnce).toBeTruthy()
			expect(@eventSpy.calledWith(@account, "password empty")).toBeTruthy()
	
		it "should be able to check if a username exists", ->
			@account.username_available('chris')
			expect(@stub).toHaveBeenCalled()

	describe "When the username available AJAX request is executed", ->
		beforeEach ->
			@server = sinon.fakeServer.create()
			@spy = sinon.spy()
			@account.bind 'username_taken', @spy

		afterEach ->
			@server.restore()

		it "should fire an event when ajax req 200", ->
			@server.respondWith "POST", "/users/username_available",
				[200, {"Content-Type" : "application/json" },
				'{ "response" : "lol" }'
				]
			@account.username_available 'wotsit'
			@server.respond()
			expect(@spy).toHaveBeenCalledOnce()
			expect(@spy).toHaveBeenCalledWith(true)

		it "should fire an event when ajax req fails", ->
			@server.respondWith "POST", "/users/username_available",
				[400, {"Content-Type" : "application/json" },
				'{ "response" : "lol" }'
				]
			@account.username_available 'wotsit'
			@server.respond()
			expect(@spy).toHaveBeenCalledTwice()
			expect(@spy).toHaveBeenCalledWith(false)
