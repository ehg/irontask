describe "View: Rubbish", ->
	describe "When rendered", ->
		beforeEach ->
			setFixtures "<div class='rubbish'></div><div class='rubbish'></div><div id='dragtest'></div>"
			$.fx.off = true
			@view = new IronTask.Views.Rubbish
			@spy = sinon.spy @view, "toggleBounce"
			@view.render()

		afterEach ->
			$.fx.off = false
		
		it "bounces in two rubbish bin bars", ->
			expect(@spy).toHaveBeenCalledOnce()
			expect($('.rubbish').length).toEqual 2

		it "allows items to be dropped on them", ->
			expect($('.rubbish')).toHaveClass 'ui-droppable'
		
		it "shows an image and a message", ->
			expect($('.rubbish .notice-content')[0]).toHaveText " Drag here to remove"
			expect($('.rubbish .notice-content img')[0]).not.toBeNull()

		describe "When an item is dropped", ->
			beforeEach ->
				model = new Backbone.Model
				drop_func = $('.rubbish').first().droppable 'option', 'drop'
				event = new $.Event
				ui = {}
				draggable = $('#dragtest')
				draggable.draggable()
				draggable.data 'model', model
				ui.draggable = draggable
				@spy = sinon.spy model, "destroy"
				drop_func(event, ui)

			it "deletes the item", ->
				expect(@spy).toHaveBeenCalledOnce()
		
