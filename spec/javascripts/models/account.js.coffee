describe "Account", ->
	it "should exhibit attributes", ->
		account = new Privydo.Models.Account ( {username : 'test', password : 'testing'} )
		expect(account.get('username')).toEqual('test')
	it "should make a new account", ->
		sinon.spy jQuery, "ajax"
		account = new Privydo.Models.Account ( {username : 'test', password : 'testing'} )
		account.save()
		expect(jQuery.ajax).toHaveBeenCalled()
		jQuery.ajax.restore()

	it "should SHA256 the password", ->
		hash = Privydo.Models.Account.hash('testing')
		expect(hash).toNotBe(null)
		expect(hash).toNotEqual('testing')

	it "should display an error if the username is empty", ->
		account = new Privydo.Models.Account
		eventSpy = sinon.spy()
		account.bind("error", eventSpy)
		account.save({ username : '', password : 'testing' })
		expect(eventSpy.calledOnce).toBeTruthy()
		expect(eventSpy.calledWith(account, "username empty")).toBeTruthy()

	it "should display an error if the password is empty", ->
		account = new Privydo.Models.Account
		eventSpy = sinon.spy()
		account.bind("error", eventSpy)
		account.save({ username : 'test', password : '' })
		expect(eventSpy.calledOnce).toBeTruthy()
		expect(eventSpy.calledWith(account, "password empty")).toBeTruthy()

	xit "should display an error if the username already exists", ->

