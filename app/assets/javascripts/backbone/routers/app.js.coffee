class Privydo.Routers.Signup extends Backbone.Router

	routes: {
		"" : "new"
		}

	new: ->
		alert 'new'
		new Privydo.Views.Signup { model: new Privydo.Models.Account }
