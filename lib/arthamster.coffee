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
    @jcanvas.mousedown (e) => 
      @draw = true if @tool == "pen"
      @rectangle(e, 20, 20) if @tool == "rectangle"
      @circle(e, 20) if @tool == "circle"
    @jcanvas.mouseup =>
      @draw = false
    @jcanvas.mousemove (e) => 
      @pen(e)
    @set_up_pallet()

  set_up_pallet: ->
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

  rectangle: (e, width, height) ->
    console.log(@tool)
    @context.fillStyle = @color
    @context.fillRect(e.pageX, e.pageY, width, height)

  circle: (e, radius) ->
    @context.fillStyle= @color;
    @context.beginPath();
    @context.arc(e.pageX,e.pageY,radius,0,Math.PI*2,true);
    @context.closePath();
    @context.fill();

  pen: (e) ->
    if @draw == true && @tool = "pen"
      @context.lineWidth = 5;
      @context.lineCap = "round";
      @context.beginPath();
      @context.strokeStyle = @color
      @context.moveTo(e.pageX,e.pageY);
      @context.lineTo(e.pageX+1,e.pageY+1);
      @context.stroke();

  background_image: (image) ->
    img = new Image()
    img.src = image
    img.onload = @context.drawImage(img,0,0)
      


$ ->
  mycanvas = new Arthamster("example")

