class Privydo.Routers.Signup extends Backbone.Router

	routes: {
		"" : "new"
		}

	new: ->
		new Privydo.Views.Signup { model: new Privydo.Models.Account }
