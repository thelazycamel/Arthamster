(function() {
  var Arthamster;

  Arthamster = (function() {

    function Arthamster(canvas_id) {
      var _this = this;
      this.canvas_id = canvas_id;
      this.canvas = document.getElementById(canvas_id);
      this.jcanvas = $("#" + canvas_id);
      this.context = this.canvas.getContext('2d');
      this.draw = false;
      this.tool = "pen";
      this.color = "black";
      this.tool_size = 10;
      this.jcanvas.mousedown(function(e) {
        if (_this.tool === "pen") _this.draw = true;
        if (_this.tool === "square") _this.square(e);
        if (_this.tool === "circle") return _this.circle(e);
      });
      this.jcanvas.mouseup(function() {
        return _this.draw = false;
      });
      this.jcanvas.mousemove(function(e) {
        return _this.pen(e);
      });
      this.set_up_toolkit();
    }

    Arthamster.prototype.set_up_toolkit = function() {
      var _this = this;
      $("#tool_size").change(function(e) {
        return _this.tool_size = e.target.value;
      });
      $(".tool").click(function(e) {
        $(".tool").css({
          "color": "grey"
        });
        $("#" + _this.tool).css({
          "color": "" + _this.color
        });
        return _this.tool = e.target.id;
      });
      $(".color").click(function(e) {
        _this.color = e.target.id;
        $(".color").css({
          "color": "grey"
        });
        $("#" + _this.color).css({
          "color": "" + _this.color
        });
        return $("#" + _this.tool).css({
          "color": "" + _this.color
        });
      });
      return $(".image").click(function(e) {
        return _this.background_image(e.target.dataset.src);
      });
    };

    Arthamster.prototype.x = function(e) {
      return e.pageX - this.canvas.offsetLeft;
    };

    Arthamster.prototype.y = function(e) {
      return e.pageY - this.canvas.offsetTop;
    };

    Arthamster.prototype.square = function(e) {
      console.log(this.tool);
      this.context.fillStyle = this.color;
      return this.context.fillRect(this.x(e) - (this.tool_size / 2), this.y(e) - (this.tool_size / 2), this.tool_size, this.tool_size);
    };

    Arthamster.prototype.circle = function(e) {
      this.context.fillStyle = this.color;
      this.context.beginPath();
      this.context.arc(this.x(e), this.y(e), this.tool_size / 2, 0, Math.PI * 2, true);
      this.context.closePath();
      return this.context.fill();
    };

    Arthamster.prototype.pen = function(e) {
      if (this.draw === true && this.tool === "pen") {
        this.context.lineWidth = this.tool_size;
        this.context.lineCap = "round";
        this.context.beginPath();
        this.context.strokeStyle = this.color;
        this.context.moveTo(this.x(e), this.y(e));
        this.context.lineTo(this.x(e) + 1, this.y(e) + 1);
        return this.context.stroke();
      }
    };

    Arthamster.prototype.background_image = function(image) {
      var img;
      img = new Image();
      img.src = image;
      return img.onload = this.context.drawImage(img, 0, 0);
    };

    return Arthamster;

  })();

  $(function() {
    var mycanvas;
    return mycanvas = new Arthamster("example");
  });

}).call(this);
