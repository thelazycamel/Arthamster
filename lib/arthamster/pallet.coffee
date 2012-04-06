class Palette
  constructor: (colors) ->
    @colors = colors
    @palette = $("#palette #colors")
    @build_palette()

  build_palette: ->
    @palette.html("")
    for color in @colors
      @palette.append("<a href='#' id='#{color}' style='background-color: ##{color}' class='color'></a>")