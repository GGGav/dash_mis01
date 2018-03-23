class Dashing.Misalert2 extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    $(@node).fadeOut().fadeIn()

  @accessor 'isTooHigh', ->
    @get('value') > 300

  @accessor 'isNotZero', ->
    @get('value') > 0

  @accessor 'always', ->
    1 > 0
