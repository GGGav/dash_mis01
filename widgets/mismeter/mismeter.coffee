class Dashing.Mismeter extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".meter").val(value).trigger('change')

  ready: ->
    meter = $(@node).find(".meter")
    meter.attr("data-bgcolor", meter.css("background-color"))
    meter.attr("data-fgcolor", meter.css("color"))
    meter.knob()
    @onData(this)

  onData: (data) ->
    console.log data.value + ' ' + @get('threshold1') + ' ' + @get('threshold2')

    if not data.value?
      console.log "Remove all"
      $(@node).removeClass('good')
      $(@node).removeClass('bad')
    else if data.value > @get('threshold2')
      console.log "Add bad"
      $(@node).addClass('bad')
      $(@node).removeClass('good')
      $(@node).removeClass('middle')
    else if (data.value > @get('threshold1')) && (data.value < @get('threshold2'))
      console.log "Add middle"
      $(@node).addClass('middle')
      $(@node).removeClass('bad')
      $(@node).removeClass('good')
    else
      console.log "Add good"
      $(@node).addClass('good')
      $(@node).removeClass('bad')
      $(@node).removeClass('middle')
