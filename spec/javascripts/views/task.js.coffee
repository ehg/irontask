describe "Task view", ->
	beforeEach ->
		@model = new Backbone.Model
			id: 1
			text: "My task"
			date: new Date(2011, 7, 20)
			done: false
		@view = new Privydo.Views.Task( {model: @model} )
		setFixtures '<ul id="tasks"></ul>'

	describe "Rendering", ->
		beforeEach ->
			$('#tasks').append(@view.render().el)

		it "returns the view object", ->
			expect(@view.render()).toEqual(@view)

		it "has the correct text", ->
			expect($('#tasks').find('h2')).toHaveText('My task')
