describe "View: Contexts", ->
	beforeEach ->
		setFixtures "<img id='add-context'><ul id='context-list'></ul>"
	
	describe "Rendering", ->
		beforeEach ->
			@contextView = new Backbone.View
			@contextView.render = ->
				@el = document.createElement 'li'
				@
			@contextRenderSpy = sinon.spy @contextView, "render"
			@contextViewStub = sinon.stub(window.Privydo.Views, "Context").returns @contextView

			@c1 = new Backbone.Model {id:1}
			@c2 = new Backbone.Model {id:2}
			@c3 = new Backbone.Model {id:3}

			@view = new Privydo.Views.Contexts {collection: new Backbone.Collection [@c1, @c2, @c3]}
			@view.addContexts()

		afterEach ->
			window.Privydo.Views.Context.restore()

		it "creates a Context view for each context item", ->
			expect(@contextViewStub).toHaveBeenCalledThrice()
			expect(@contextViewStub).toHaveBeenCalledWith({model: @c1})
			expect(@contextViewStub).toHaveBeenCalledWith({model: @c2})
			expect(@contextViewStub).toHaveBeenCalledWith({model: @c3})

		it "renders each Context view", ->
			expect(@contextRenderSpy).toHaveBeenCalledThrice()

		it "appends the context to the context list", ->
			expect($(@view.el).children().length).toEqual 3

		it "should have the class ui-sortable", ->
			expect(@view.el).toHaveClass 'ui-sortable'

		describe "When the add new list button is clicked", ->
			it "adds a new task to the collection", ->
				@addContextView = new Privydo.Views.AddContext { collection: @view.collection }
				spy = sinon.spy @view.collection, "add"
				@addContextView.addNew()
				expect(spy).toHaveBeenCalledOnce()


