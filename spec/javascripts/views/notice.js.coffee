describe "View: Notice", ->
	beforeEach ->
		jQuery.fx.off = true
		@clock = sinon.useFakeTimers()
		setFixtures "<div id='notice-bar'></div>"

	afterEach ->
		@clock.restore()
		jQuery.fx.off = false

	describe "When the message is text", ->
		beforeEach ->
			@view = new IronTask.Views.Notice {message: 'Test message'}
			@view.render()

		it "shows the notice bar", ->
			expect(@view.el).toBeVisible()

		it "hides the notice bar after 5 secs", ->
			@clock.tick 5000
			expect(@view.el).not.toBeVisible()

	describe "When the message is JSON (validation from server)", ->
		beforeEach ->
			@view = new IronTask.Views.Notice {message: JSON.stringify [{"magic_word" : "wrong"}, {"something" : "elsewrong"}] }
			@view.render()

		it "renders the errors in a list", ->
			expect($(@view.el).find 'ul').not.toBeEmpty()
