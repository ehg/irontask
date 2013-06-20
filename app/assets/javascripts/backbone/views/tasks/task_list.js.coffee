#=require datejs/date-en-GB
#=require ui.multisortable.js
class IronTask.Views.TaskList extends Backbone.View
  tagName: 'ul'

  initialize: ->
    _.bindAll this, 'addTasks', 'addTask', 'change'
    @collection.bind 'resort', @change, @
    @setSortable()
    @detectEndOfDay()

  change: ->
    console.log 'change'
    @setSelectedContexts contexts.selected()
    @collection.sort()
    @addTasks()

  addTasks: ->
    tasks = @collection.notdone_or_done_today()
    if tasks.length > 0
      $(@el).html ''
      tasks.each @addTask
    else
      $(@el).html "<span id='task-placeholder'>You haven't got anything to do!</span>"
    @

  addTask: (task) ->
    view = new IronTask.Views.Task {model: task}
    $(@el).append view.render().el
    
  setSelectedContexts: (contexts) -># how can we test this? coupled? move to collection
    @collection.reset tasks.filterWithContexts(contexts)
    @addTasks()

  setSortable: ->
    rubbish = new IronTask.Views.Rubbish
    $(@el).multisortable
      scroll: false
      opacity: 0.5
      handle: '.mover'
      distance: 4
#       placeholder: 'ui-state-highlight'
      pointer: 'move'
      tolerance: 'pointer'
      start: (event, ui) =>
        @setSortableItems ui
        rubbish.render()
      update: (event, ui) =>
        @saveSortOrder()
      stop: (events, ui) =>
        $(@el).multisortable 'option', 'items', "li"
        $(@el).multisortable 'refresh'
        $(@el).find('li').removeClass('ui-multisort-grouped')
        rubbish.hide()
    

  setSortableItems: (ui) ->
    klass = if $('.ui-multisort-grouped').length == 0 then $(ui.item).attr('class').split(' ')[0] else 'none'
    $(@el).multisortable 'option', 'items', ".#{klass}"
    $(@el).multisortable 'refresh'
  
  saveSortOrder: ->
    tasks = @$('li')
    for el, i in tasks
      model = $(el).data('model')
      model.save {order: i}, {silent:true} if model
  
  detectEndOfDay: ->
    @currentDay = Date.today().dayOfYear
    setInterval =>
      if @currentDay < Date.today().dayOfYear
        @change()
        @currentDay = Date.today().dayOfYear
    , 30000

