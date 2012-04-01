#to compile to js: coffee -c -o scripts lib
#to compile automatically coffee -w -c -o scripts lib

class Arthamster
  constructor: (canvas_id) ->
    @canvas_id = canvas_id
    @canvas = document.getElementById(canvas_id)
    @jcanvas = $("##{canvas_id}")
    @context = @canvas.getContext('2d')
    @draw = false
    @tool = "pen"
    @color = "black"
    @tool_size = 10
    @text = ""
    @jcanvas.mousedown (e) => 
      @draw = true if @tool == "pen"
      @square(e) if @tool == "square"
      @circle(e) if @tool == "circle"
      @text_tool(e) if @tool == "text"
    @jcanvas.mouseup =>
      @draw = false
    @jcanvas.mousemove (e) => 
      @pen(e)
    @set_up_toolkit()

  set_up_toolkit: ->
    $("#tool_size").change (e) =>
      @tool_size = e.target.value
    $(".tool").click (e) =>
      @tool = e.target.id
      $(".tool").css({"color": "grey"})
      $("##{@tool}").css({"color": "black"})
      return false
    $("#palette a.color").click (e) =>
      @color = "##{e.target.id}"
      $("#current_color").css({"backgroundColor": @color})
      return false
    $(".image").click (e) =>
      @background_image(e.target.dataset.src)
      return false
    $("#clear").click =>
      @clear()
      return false
    $("#text_value").change =>
      @text = $("#text_value").val()

  x: (e) ->
    e.pageX - @canvas.offsetLeft 
    
  y: (e) ->
    e.pageY - @canvas.offsetTop

  square: (e) ->
    @context.fillStyle = @color
    @context.fillRect(@x(e) - (@tool_size / 2), @y(e) - (@tool_size / 2), @tool_size, @tool_size)

  circle: (e) ->
    @context.fillStyle= @color;
    @context.beginPath();
    @context.arc(@x(e), @y(e), @tool_size / 2, 0, Math.PI*2, true);
    @context.closePath();
    @context.fill();

  pen: (e) ->
    if @draw == true && @tool == "pen"
      @context.lineWidth = @tool_size;
      @context.lineCap = "round";
      @context.beginPath();
      @context.strokeStyle = @color
      @context.moveTo(@x(e), @y(e));
      @context.lineTo(@x(e) + 1, @y(e) + 1);
      @context.stroke();

  text_tool: (e) ->
    @context.fillStyle    = @color
    @context.font         = "normal #{@tool_size}px sans-serif"
    @context.textBaseline = "top"
    @context.fillText(@text, @x(e), @y(e))

  clear: ->
    @context.fillStyle = "#ffffff"
    @context.fillRect(0, 0, @jcanvas.width(), @jcanvas.height())

  background_image: (image) ->
    img = new Image()
    img.src = image
    img.onload = @context.drawImage(img,0,0)


class Palette
  constructor: (colors) ->
    @colors = colors
    @palette = $("#palette #colors")
    @build_palette()

  build_palette: ->
    for color in @colors
      @palette.append("<a href='#' id='#{color}' style='background-color: ##{color}' class='color'></a>")
      


$ ->
  my_palette = new Palette(web_216)
  mycanvas = new Arthamster("example")

web_216 = [ "FFFFFF",
            "FFFFCC",
            "FFFF99",
            "FFFF66",
            "FFFF33",
            "FFFF00",
            "FFCCFF",
            "FFCCCC",
            "FFCC99",
            "FFCC66",
            "FFCC33",
            "FFCC00",
            "FF99FF",
            "FF99CC",
            "FF9999",
            "FF9966",
            "FF9933",
            "FF9900",
            "FF66FF",
            "FF66CC",
            "FF6699",
            "FF6666",
            "FF6633",
            "FF6600",
            "FF33FF",
            "FF33CC",
            "FF3399",
            "FF3366",
            "FF3333",
            "FF3300",
            "FF00FF",
            "FF00CC",
            "FF0099",
            "FF0066",
            "FF0033",
            "FF0000",
            "CCFFFF",
            "CCFFCC",
            "CCFF99",
            "CCFF66",
            "CCFF33",
            "CCFF00",
            "CCCCFF",
            "CCCCCC",
            "CCCC99",
            "CCCC66",
            "CCCC33",
            "CCCC00",
            "CC99FF",
            "CC99CC",
            "CC9999",
            "CC9966",
            "CC9933",
            "CC9900",
            "CC66FF",
            "CC66CC",
            "CC6699",
            "CC6666",
            "CC6633",
            "CC6600",
            "CC33FF",
            "CC33CC",
            "CC3399",
            "CC3366",
            "CC3333",
            "CC3300",
            "CC00FF",
            "CC00CC",
            "CC0099",
            "CC0066",
            "CC0033",
            "CC0000",
            "99FFFF",
            "99FFCC",
            "99FF99",
            "99FF66",
            "99FF33",
            "99FF00",
            "99CCFF",
            "99CCCC",
            "99CC99",
            "99CC66",
            "99CC33",
            "99CC00",
            "9999FF",
            "9999CC",
            "999999",
            "999966",
            "999933",
            "999900",
            "9966FF",
            "9966CC",
            "996699",
            "996666",
            "996633",
            "996600",
            "9933FF",
            "9933CC",
            "993399",
            "993366",
            "993333",
            "993300",
            "9900FF",
            "9900CC",
            "990099",
            "990066",
            "990033",
            "990000",
            "66FFFF",
            "66FFCC",
            "66FF99",
            "66FF66",
            "66FF33",
            "66FF00",
            "66CCFF",
            "66CCCC",
            "66CC99",
            "66CC66",
            "66CC33",
            "66CC00",
            "6699FF",
            "6699CC",
            "669999",
            "669966",
            "669933",
            "669900",
            "6666FF",
            "6666CC",
            "666699",
            "666666",
            "666633",
            "666600",
            "6633FF",
            "6633CC",
            "663399",
            "663366",
            "663333",
            "663300",
            "6600FF",
            "6600CC",
            "660099",
            "660066",
            "660033",
            "660000",
            "33FFFF",
            "33FFCC",
            "33FF99",
            "33FF66",
            "33FF33",
            "33FF00",
            "33CCFF",
            "33CCCC",
            "33CC99",
            "33CC66",
            "33CC33",
            "33CC00",
            "3399FF",
            "3399CC",
            "339999",
            "339966",
            "339933",
            "339900",
            "3366FF",
            "3366CC",
            "336699",
            "336666",
            "336633",
            "336600",
            "3333FF",
            "3333CC",
            "333399",
            "333366",
            "333333",
            "333300",
            "3300FF",
            "3300CC",
            "330099",
            "330066",
            "330033",
            "330000",
            "00FFFF",
            "00FFCC",
            "00FF99",
            "00FF66",
            "00FF33",
            "00FF00",
            "00CCFF",
            "00CCCC",
            "00CC99",
            "00CC66",
            "00CC33",
            "00CC00",
            "0099FF",
            "0099CC",
            "009999",
            "009966",
            "009933",
            "009900",
            "0066FF",
            "0066CC",
            "006699",
            "006666",
            "006633",
            "006600",
            "0033FF",
            "0033CC",
            "003399",
            "003366",
            "003333",
            "003300",
            "0000FF",
            "0000CC",
            "000099",
            "000066",
            "000033",
            "000000"]

