class Pallet
  constructor: (colors) ->
    @colors = colors
    @pallet = $("#arthamster_pallet #colors")
    @build_pallet()

  build_pallet: ->
    @pallet.html("")
    for color in @colors
      @pallet.append("<a href='#' id='#{color}' style='background-color: ##{color}' class='color'></a>")