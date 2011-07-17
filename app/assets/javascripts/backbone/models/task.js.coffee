class Privydo.Models.Task extends Backbone.Model
  paramRoot: 'task'

  
class Privydo.Collections.TasksCollection extends Backbone.Collection
  model: Privydo.Models.Task
  url: '/tasks'
