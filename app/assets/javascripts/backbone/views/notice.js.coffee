#= require jquery.dotimeout
class IronTask.Views.Notice extends Backbone.View
  className: "success"
  displayLength: 5000
  defaultMessage: ''
  el: '#notice-bar'

  initialize: ->
    _.bindAll this, 'render'
    @display = @options.message || @defaultMessage
    try
      @display = @parseErrors(@display)
    @render()

  render: ->
    $(@el).find('.notice-content').html(@display)
    $(@el).addClass @className
    $(@el).fadeIn('slow')
    jQuery.doTimeout @displayLength, =>
      $(@el).fadeOut('slow')
    @

  parseErrors: (json) ->
    display = "<ul class='notice-list'>"
    for field, errorText of jQuery.parseJSON(json)
      display += "<li>#{errorText}</li>"
    @displayLength = @displayLength * 2
    display + '</ul>'


class IronTask.Views.Error extends IronTask.Views.Notice
  className: "error"
  defaultMessage: "Shit. It's all gone wrong :("
