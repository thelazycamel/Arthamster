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
      this.jcanvas.mousedown(function(e) {
        if (_this.tool === "pen") _this.draw = true;
        if (_this.tool === "rectangle") _this.rectangle(e, 20, 20);
        if (_this.tool === "circle") return _this.circle(e, 20);
      });
      this.jcanvas.mouseup(function() {
        return _this.draw = false;
      });
      this.jcanvas.mousemove(function(e) {
        return _this.pen(e);
      });
      this.set_up_pallet();
    }

    Arthamster.prototype.set_up_pallet = function() {
      var _this = this;
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

    Arthamster.prototype.rectangle = function(e, width, height) {
      console.log(this.tool);
      this.context.fillStyle = this.color;
      return this.context.fillRect(e.pageX, e.pageY, width, height);
    };

    Arthamster.prototype.circle = function(e, radius) {
      this.context.fillStyle = this.color;
      this.context.beginPath();
      this.context.arc(e.pageX, e.pageY, radius, 0, Math.PI * 2, true);
      this.context.closePath();
      return this.context.fill();
    };

    Arthamster.prototype.pen = function(e) {
      if (this.draw === true && (this.tool = "pen")) {
        this.context.lineWidth = 5;
        this.context.lineCap = "round";
        this.context.beginPath();
        this.context.strokeStyle = this.color;
        this.context.moveTo(e.pageX, e.pageY);
        this.context.lineTo(e.pageX + 1, e.pageY + 1);
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
