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
    @jcanvas.mousedown (e) => 
      @draw = true if @tool == "pen"
      @square(e) if @tool == "square"
      @circle(e) if @tool == "circle"
    @jcanvas.mouseup =>
      @draw = false
    @jcanvas.mousemove (e) => 
      @pen(e)
    @set_up_toolkit()

  set_up_toolkit: ->
    $("#tool_size").change (e) =>
      @tool_size = e.target.value
    $(".tool").click (e) =>
      $(".tool").css({"color": "grey"})
      $("##{@tool}").css({"color": "#{@color}"})
      @tool = e.target.id
    $(".color").click (e) =>
      @color = e.target.id
      $(".color").css({"color": "grey"})
      $("##{@color}").css({"color": "#{@color}"})
      $("##{@tool}").css({"color": "#{@color}"})
    $(".image").click (e) =>
      @background_image(e.target.dataset.src)

  x: (e) ->
    e.pageX - @canvas.offsetLeft 
    
  y: (e) ->
    e.pageY - @canvas.offsetTop

  square: (e) ->
    console.log(@tool)
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

  background_image: (image) ->
    img = new Image()
    img.src = image
    img.onload = @context.drawImage(img,0,0)
      


$ ->
  mycanvas = new Arthamster("example")

