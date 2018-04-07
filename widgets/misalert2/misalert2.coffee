class Dashing.Misalert2 extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # The following line will 'blink' the widget when new data is received
    $(@node).fadeOut().fadeIn()

  @accessor 'isGreaterThan', ->
    @get('value') > @get('threshold')

  @accessor 'isNotZero', ->
    @get('value') > 0

  @accessor 'always', ->
    1 > 0
