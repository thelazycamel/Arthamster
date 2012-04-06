
class Arthamster
  constructor: (canvas_id) ->
    @canvas_id = canvas_id
    @canvas = document.getElementById(canvas_id)
    @jcanvas = $("##{canvas_id}")
    @context = @canvas.getContext('2d')
    @restore_points = []
    @draw = false
    @tool = "pencil"
    @color = "black"
    @tool_size = 10
    @text = ""
    @mouse_events()
    @set_up_toolkit()

  mouse_events: ->
    @jcanvas.mousedown (e) => 
      @draw = true if @tool == "pencil"
      @square(e) if @tool == "square"
      @circle(e) if @tool == "circle"
      @text_tool(e) if @tool == "text"
      @set_restore_point()
    @jcanvas.mouseup =>
      @draw = false
    @jcanvas.mousemove (e) => 
      @pencil(e)

  set_up_toolkit: ->
    #set up the jquery click events for the toolkit
    $("#pencil").addClass("selected_tool")
    $("#tool_size").change (e) =>
      @tool_size = e.target.value
    $(".tool").click (e) =>
      @tool = e.target.id
      $(".tool").removeClass("selected_tool")
      $("##{@tool}").addClass("selected_tool")
      return false
    $("#palette").on "click", "a.color", (e) =>
      @color = "##{e.target.id}"
      $("#current_color").css({"backgroundColor": @color})
      return false
    $("#image").click (e) =>
      @image(e.target.dataset.src)
      return false
    $("#pallet_changer").change (e) =>
      new_palette = new Palette(eval(e.target.value))
    $("#clear").click =>
      @clear()
      return false
    $("#undo").click =>
      unless @restore_points.length == 0
        @clear() 
        @image(@restore_points.pop())
      return false
    $("#text_value").change =>
      @text = $("#text_value").val()

  x: (e) ->
    e.pageX - @canvas.offsetLeft 
    
  y: (e) ->
    e.pageY - @canvas.offsetTop

  set_restore_point: ->
    @restore_points.push(@canvas.toDataURL("image/png"))
    if @restore_points.length > 4
      @restore_points.splice(0,1)

  square: (e) ->
    @context.fillStyle = @color
    @context.fillRect(@x(e) - (@tool_size / 2), @y(e) - (@tool_size / 2), @tool_size, @tool_size)

  circle: (e) ->
    @context.fillStyle= @color;
    @context.beginPath();
    @context.arc(@x(e), @y(e), @tool_size / 2, 0, Math.PI*2, true);
    @context.closePath();
    @context.fill();

  pencil: (e) ->
    if @draw == true && @tool == "pencil"
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

  image: (url) ->
    img = new Image()
    img.src = url
    img.onload = =>
      @context.drawImage(img,0,0)

      