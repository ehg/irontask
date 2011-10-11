describe "Views: Context", ->
	beforeEach ->
		@model = new Backbone.Model
			id: 1
			text: 'My list'
		@model.select = ->
			'woot'
		@model.deselect = (multi) ->
			'woot2'
		@model.save = ->
			'woot33'
		@view = new Privydo.Views.Context {model: @model}
		setFixtures "<ul id='contexts-list'></ul>"

	describe "On render", ->
		beforeEach ->
			@selectSpy = sinon.spy @model, "select"
			@deselectSpy = sinon.spy @model, "deselect"
			$('#contexts-list').append @view.render().el
			@context = $('ul#contexts-list li:first')

		it "returns the view object", ->
			expect(@view.render()).toEqual(@view)

		it "has the correct text", ->
			expect(@context.find '.display .context').toHaveText 'My list'

		describe "When clicked", ->
			beforeEach ->
				@e = $.Event 'singleclick'
				@e.ctrlKey = false
				@e.metaKey = false
	
			it "selects a context when clicked", ->
				@context.find('.display .context').trigger @e
				expect(@selectSpy).toHaveBeenCalledOnce()
	
		describe "When context double clicked", ->
			beforeEach ->
				@spy = sinon.spy @model, "save"
				e = $.Event 'doubleclick'
				@context.find('.display .context').trigger e

			it "sets the class to editing", ->
				expect(@context).toHaveClass 'editing'
	
			it "saves context when blurred", ->
				@context.find('input').blur()
				expect(@spy).toHaveBeenCalledOnce()
	
			it "saves context when enter pressed", ->
				e = $.Event 'keyup'
				e.keyCode = 13
				@context.find('input').trigger e
				expect(@spy).toHaveBeenCalledOnce()
	
		describe "When contexts ctrl/meta clicked", ->
			beforeEach ->
				@e = $.Event 'singleclick'
				@e.ctrlKey = true
				@e.metaKey = false

			it "calls select with multiple set to true on unselected context", ->
				@context.find('.display .context').trigger @e
				expect(@selectSpy).toHaveBeenCalledOnce()
				expect(@selectSpy).toHaveBeenCalledWith(true)

			it "calls deselect on selected context", ->
				@context.addClass 'selected'
				@context.find('.display .context').trigger @e
				expect(@deselectSpy).toHaveBeenCalledOnce()
		
		describe "When the context is a new one", ->
			it "selects it when saved"
			it "focuses the input"

