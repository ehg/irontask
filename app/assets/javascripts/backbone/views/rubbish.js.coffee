class IronTask.Views.Rubbish extends Backbone.View
  template: JST['backbone/templates/rubbish']
  el: '.rubbish'

  initialize: ->
    $('.rubbish').droppable(
      tolerance: 'touch'
      over: ->
        $(@).find('.notice-content').fadeTo 100, 0.7
      out: ->
        $(@).find('.notice-content').fadeTo 100, 1.0
      drop: (event, ui) =>
        models = []
        for draggable, i in ui.helper
          models.push  $($(ui.helper)[i]).data('model')
        _.each models, (model) -> model.destroy()
        $(ui.helper).remove()
    )

  render: ->
    $('.rubbish').html @template()
    @show()
    @
  
  show: ->
    $('#footer-container').height $('#footer-container').height() * 2
    $('.rubbish').effect "bounce", { times: 2, mode: 'show', direction: 'down'}, 300
  
  hide: ->
    $('.rubbish').effect "bounce", { times: 2, mode: 'hide', direction: 'down'}, 300, ->
      $('#footer-container').height 37

