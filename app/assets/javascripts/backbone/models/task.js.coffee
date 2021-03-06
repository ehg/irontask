#= require pidcrypt/aes_cbc
#= require cookies
class IronTask.Models.Task extends Backbone.Model
  defaults:
    'done'       : false
    'order'      : -1

  url: ->
    if @get('id') > 0 then "/tasks/#{@get 'id'}" else '/tasks'

  validate: (attrs) ->
    return "Please enter some text." if 'text' of attrs and attrs.text.length < 1
    return "That's too long, sorry." if 'text' of attrs and attrs.text and attrs.text.length > 60
    return "For some reason, done hasn't been specified." if 'done' of attrs and !(attrs.done in [true, false])
    return "That's an invalid date, see help for more details." if 'date' of attrs and (!_.isDate(attrs.date) and attrs.date != null)
    return "No contexts seem to have been specified" if 'contexts' of attrs and (!_.isArray(attrs.contexts) or attrs.contexts.length < 1)

  @parse: (res) ->
    plaintext = res.content#decrypt res.content, getCookieValue 'key'
    content = $.parseJSON(plaintext)
    return if content is null
    object =
      id : res.id
      text: content.text
      date: if content.date? then new Date(content.date) else null
      doneDate: if content.doneDate? then new Date(content.doneDate) else null
      order: content.order || -1
      done: res.done
      contexts: content.contexts
    delete object.date if object.date is null
    object

  parse: (res) ->
    if res.id then return { id : res.id }
    IronTask.Models.Task.parse(res)

  sync: (method, model, options) ->
    if method == "create" or method == "update"
      data =
        'content' : JSON.stringify content(model)
        'done' : model.get 'done'
      options.data = JSON.stringify data
      options.contentType = 'application/json'
    Backbone.sync method, model, options

  content = (m) ->
    'text' : m.get 'text'
    'date' : m.get 'date'
    'doneDate' : m.get 'doneDate'
    'order' : m.get 'order'
    'contexts': m.get 'contexts'

  save: (attr, options) ->
    if attr and attr.date
      attr.date = attr.date.trim()
      attr.date = "next #{attr.date}" if attr.date.toUpperCase() in ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
      attr.date = Date.parse attr.date
      super attr, options
    else
      super attr, options

  putOff: ->
    yesterday = Date.today().addDays(-1)
    oldDate = @get('date') || yesterday
    oldDate = yesterday if oldDate.compareTo(yesterday) == -1
    newDate = oldDate.add(1).days()
    @set { date : newDate }, {silent: true}
    @change()

  putOffSave: ->
    @save {}

  toggleDone: ->
    @save { done : not @get('done'), doneDate : Date.today() }

  destroy: ->
    window.tasks.remove @
    super

  moveTo: (context) ->
    @save { contexts: [context] }
    @trigger 'resort', @

class IronTask.Models.Tasks extends Backbone.Collection
  model: IronTask.Models.Task
  url: '/tasks'

  parse: (res) ->
    _.map(res, (o) ->
      IronTask.Models.Task.parse(o)
    )

  done: ->
    @filter (task) -> task.get('done') == true

  notdone: ->
    @filter (task) -> task.get('done') == false

  filterWithContexts: (contexts) ->
    ids = _.map contexts, (c) ->
      c.get('id')
    @models.filter (t) ->
      _.intersectiont(t.get('contexts'), ids).length > 0

class IronTask.Models.DisplayTasks extends IronTask.Models.Tasks
  comparator: (task) ->
    date = task.get('date') || new Date(2998,5,1)
    order = task.get('order') || 0
    date_order = date.getTime() + order
    "#{date_order}|#{task.get('text').toUpperCase()}"

  notdone_or_done_today: ->
    new IronTask.Models.DisplayTasks @filter (task) ->
      doneDate = task.get 'doneDate'
      task.get('done') == false or task.get('done') is true and doneDate and doneDate.equals(Date.today())
