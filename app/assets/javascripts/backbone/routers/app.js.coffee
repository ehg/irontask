class IronTask.Routers.Signup extends Backbone.Router

  routes: {
    "" : "new"
    }

  new: ->
    new IronTask.Views.Signup { model: new IronTask.Models.Account }
