
class window.Arthamster
  constructor: (canvas_id, width, height) ->
    @canvas_id = canvas_id
    @canvas = document.getElementById(canvas_id)
    @jcanvas = $("##{canvas_id}")
    @canvas_width = width
    @canvas_height = height
    @context = @canvas.getContext('2d')
    @restore_points = []
    @draw = false
    @tool = "pencil"
    $("#pencil").addClass("selected_tool")
    @color = "black"
    @tool_size = 10
    @text = ""
    @set_dimensions(width, height)
    @event_listeners()

  set_dimensions: (width, height) ->
    @canvas_width = width
    @canvas_height = height
    @jcanvas.attr("width", "#{width}px")
    @jcanvas.attr("height","#{height}px")
    $("#arthamster").css({"width": "#{parseInt(width) + 107}px"})
    $("#arthamster input#width").val(width)
    $("#arthamster input#height").val(height)


  event_listeners: ->
    #set up the jquery click events for the toolkit
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
    $("#tool_size").change (e) =>
      @tool_size = e.target.value
    $(".tool").click (e) =>
      @tool = e.target.id
      $(".tool").removeClass("selected_tool")
      $("##{@tool}").addClass("selected_tool")
      return false
    $("#arthamster_pallet").on "click", "a.color", (e) =>
      @color = "##{e.target.id}"
      $("#current_color").css({"backgroundColor": @color})
      return false
    $("#width").change =>
      @set_dimensions($("#width").val(), $("#height").val())
    $("#height").change =>
      @set_dimensions($("#width").val(), $("#height").val())
    $("#image").change (e) =>
      @image_uploader(e)
    $("#pallet_changer").change (e) =>
      new_pallet = new Pallet(eval(e.target.value))
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
    @context.fillRect(0, 0, @canvas_width, @canvas_height)

  image_uploader: (e) ->
    file = e.target.files[0]
    if file.type.indexOf("image") != -1
      $("#temp_image").remove()
      img = document.createElement("img");
      img.id = "temp_image"
      reader = new FileReader()
      reader.onload = (evt) => 
        img.src = evt.target.result
        @image(reader.result)
      reader.readAsDataURL(file)
      console.log(reader)
    else
      alert("Images Only")

  image: (url) ->
    img = new Image()
    img.src = url
    ratio = 1
    canvasCopy = document.createElement("canvas");
    copyContext = canvasCopy.getContext("2d");
    maxWidth = 800
    maxHeight = 600
    img.onload = =>
      if img.width > maxWidth
        ratio = maxWidth / img.width
        if (img.height * ratio) > maxHeight
          ratio = maxHeight / img.height
      else if img.height > maxHeight
        ratio = maxHeight / img.height
      canvasCopy.width = img.width;
      canvasCopy.height = img.height;
      copyContext.drawImage(img,0,0)
      @set_dimensions(img.width * ratio, img.height * ratio)
      @context.drawImage(canvasCopy, 0, 0, canvasCopy.width, canvasCopy.height, 0, 0, @canvas.width, @canvas.height)

      