(function() {
  var Pallet, pallet_grey_scale, pallet_web_216;

  window.Arthamster = (function() {

    function Arthamster(canvas_id, width, height) {
      this.canvas_id = canvas_id;
      this.canvas = document.getElementById(canvas_id);
      this.jcanvas = $("#" + canvas_id);
      this.canvas_width = width;
      this.canvas_height = height;
      this.context = this.canvas.getContext('2d');
      this.restore_points = [];
      this.draw = false;
      this.tool = "pencil";
      $("#pencil").addClass("selected_tool");
      this.color = "black";
      this.tool_size = 10;
      this.text = "";
      this.set_dimensions(width, height);
      this.event_listeners();
    }

    Arthamster.prototype.set_dimensions = function(width, height) {
      this.canvas_width = width;
      this.canvas_height = height;
      this.jcanvas.attr("width", "" + width + "px");
      this.jcanvas.attr("height", "" + height + "px");
      $("#arthamster").css({
        "width": "" + (parseInt(width) + 107) + "px"
      });
      $("#arthamster input#width").val(width);
      return $("#arthamster input#height").val(height);
    };

    Arthamster.prototype.event_listeners = function() {
      var _this = this;
      this.jcanvas.mousedown(function(e) {
        if (_this.tool === "pencil") _this.draw = true;
        if (_this.tool === "square") _this.square(e);
        if (_this.tool === "circle") _this.circle(e);
        if (_this.tool === "text") _this.text_tool(e);
        return _this.set_restore_point();
      });
      this.jcanvas.mouseup(function() {
        return _this.draw = false;
      });
      this.jcanvas.mousemove(function(e) {
        return _this.pencil(e);
      });
      $("#tool_size").change(function(e) {
        return _this.tool_size = e.target.value;
      });
      $(".tool").click(function(e) {
        _this.tool = e.target.id;
        $(".tool").removeClass("selected_tool");
        $("#" + _this.tool).addClass("selected_tool");
        return false;
      });
      $("#arthamster_pallet").on("click", "a.color", function(e) {
        _this.color = "#" + e.target.id;
        $("#current_color").css({
          "backgroundColor": _this.color
        });
        return false;
      });
      $("#width").change(function() {
        return _this.set_dimensions($("#width").val(), $("#height").val());
      });
      $("#height").change(function() {
        return _this.set_dimensions($("#width").val(), $("#height").val());
      });
      $("#image").change(function(e) {
        return _this.image_uploader(e);
      });
      $("#pallet_changer").change(function(e) {
        var new_pallet;
        return new_pallet = new Pallet(eval(e.target.value));
      });
      $("#clear").click(function() {
        _this.clear();
        return false;
      });
      $("#undo").click(function() {
        if (_this.restore_points.length !== 0) {
          _this.clear();
          _this.image(_this.restore_points.pop());
        }
        return false;
      });
      return $("#text_value").change(function() {
        return _this.text = $("#text_value").val();
      });
    };

    Arthamster.prototype.x = function(e) {
      return e.pageX - this.canvas.offsetLeft;
    };

    Arthamster.prototype.y = function(e) {
      return e.pageY - this.canvas.offsetTop;
    };

    Arthamster.prototype.set_restore_point = function() {
      this.restore_points.push(this.canvas.toDataURL("image/png"));
      if (this.restore_points.length > 4) return this.restore_points.splice(0, 1);
    };

    Arthamster.prototype.square = function(e) {
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

    Arthamster.prototype.pencil = function(e) {
      if (this.draw === true && this.tool === "pencil") {
        this.context.lineWidth = this.tool_size;
        this.context.lineCap = "round";
        this.context.beginPath();
        this.context.strokeStyle = this.color;
        this.context.moveTo(this.x(e), this.y(e));
        this.context.lineTo(this.x(e) + 1, this.y(e) + 1);
        return this.context.stroke();
      }
    };

    Arthamster.prototype.text_tool = function(e) {
      this.context.fillStyle = this.color;
      this.context.font = "normal " + this.tool_size + "px sans-serif";
      this.context.textBaseline = "top";
      return this.context.fillText(this.text, this.x(e), this.y(e));
    };

    Arthamster.prototype.clear = function() {
      this.context.fillStyle = "#ffffff";
      return this.context.fillRect(0, 0, this.canvas_width, this.canvas_height);
    };

    Arthamster.prototype.image_uploader = function(e) {
      var file, img, reader,
        _this = this;
      file = e.target.files[0];
      if (file.type.indexOf("image") !== -1) {
        $("#temp_image").remove();
        img = document.createElement("img");
        img.id = "temp_image";
        reader = new FileReader();
        reader.onload = function(evt) {
          img.src = evt.target.result;
          return _this.image(reader.result);
        };
        reader.readAsDataURL(file);
        return console.log(reader);
      } else {
        return alert("Images Only");
      }
    };

    Arthamster.prototype.image = function(url) {
      var canvasCopy, copyContext, img, maxHeight, maxWidth, ratio,
        _this = this;
      img = new Image();
      img.src = url;
      ratio = 1;
      canvasCopy = document.createElement("canvas");
      copyContext = canvasCopy.getContext("2d");
      maxWidth = 800;
      maxHeight = 600;
      return img.onload = function() {
        if (img.width > maxWidth) {
          ratio = maxWidth / img.width;
          if ((img.height * ratio) > maxHeight) ratio = maxHeight / img.height;
        } else if (img.height > maxHeight) {
          ratio = maxHeight / img.height;
        }
        canvasCopy.width = img.width;
        canvasCopy.height = img.height;
        copyContext.drawImage(img, 0, 0);
        _this.set_dimensions(img.width * ratio, img.height * ratio);
        return _this.context.drawImage(canvasCopy, 0, 0, canvasCopy.width, canvasCopy.height, 0, 0, _this.canvas.width, _this.canvas.height);
      };
    };

    return Arthamster;

  })();

  Pallet = (function() {

    function Pallet(colors) {
      this.colors = colors;
      this.pallet = $("#arthamster_pallet #colors");
      this.build_pallet();
    }

    Pallet.prototype.build_pallet = function() {
      var color, _i, _len, _ref, _results;
      this.pallet.html("");
      _ref = this.colors;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        color = _ref[_i];
        _results.push(this.pallet.append("<a href='#' id='" + color + "' style='background-color: #" + color + "' class='color'></a>"));
      }
      return _results;
    };

    return Pallet;

  })();

  pallet_grey_scale = ["ffffff", "f1f1f1", "eeeeee", "e1e1e1", "dddddd", "d1d1d1", "cccccc", "c1c1c1", "bbbbbb", "b1b1b1", "aaaaaa", "a1a1a1", "999999", "9a9a9a", "888888", "8a8a8a", "777777", "7a7a7a", "666666", "6a6a6a", "555555", "5a5a5a", "444444", "4a4a4a", "333333", "3a3a3a", "222222", "2a2a2a", "111111", "000000"];

  pallet_web_216 = ["FFFFFF", "FFFFCC", "FFFF99", "FFFF66", "FFFF33", "FFFF00", "FFCCFF", "FFCCCC", "FFCC99", "FFCC66", "FFCC33", "FFCC00", "FF99FF", "FF99CC", "FF9999", "FF9966", "FF9933", "FF9900", "FF66FF", "FF66CC", "FF6699", "FF6666", "FF6633", "FF6600", "FF33FF", "FF33CC", "FF3399", "FF3366", "FF3333", "FF3300", "FF00FF", "FF00CC", "FF0099", "FF0066", "FF0033", "FF0000", "CCFFFF", "CCFFCC", "CCFF99", "CCFF66", "CCFF33", "CCFF00", "CCCCFF", "CCCCCC", "CCCC99", "CCCC66", "CCCC33", "CCCC00", "CC99FF", "CC99CC", "CC9999", "CC9966", "CC9933", "CC9900", "CC66FF", "CC66CC", "CC6699", "CC6666", "CC6633", "CC6600", "CC33FF", "CC33CC", "CC3399", "CC3366", "CC3333", "CC3300", "CC00FF", "CC00CC", "CC0099", "CC0066", "CC0033", "CC0000", "99FFFF", "99FFCC", "99FF99", "99FF66", "99FF33", "99FF00", "99CCFF", "99CCCC", "99CC99", "99CC66", "99CC33", "99CC00", "9999FF", "9999CC", "999999", "999966", "999933", "999900", "9966FF", "9966CC", "996699", "996666", "996633", "996600", "9933FF", "9933CC", "993399", "993366", "993333", "993300", "9900FF", "9900CC", "990099", "990066", "990033", "990000", "66FFFF", "66FFCC", "66FF99", "66FF66", "66FF33", "66FF00", "66CCFF", "66CCCC", "66CC99", "66CC66", "66CC33", "66CC00", "6699FF", "6699CC", "669999", "669966", "669933", "669900", "6666FF", "6666CC", "666699", "666666", "666633", "666600", "6633FF", "6633CC", "663399", "663366", "663333", "663300", "6600FF", "6600CC", "660099", "660066", "660033", "660000", "33FFFF", "33FFCC", "33FF99", "33FF66", "33FF33", "33FF00", "33CCFF", "33CCCC", "33CC99", "33CC66", "33CC33", "33CC00", "3399FF", "3399CC", "339999", "339966", "339933", "339900", "3366FF", "3366CC", "336699", "336666", "336633", "336600", "3333FF", "3333CC", "333399", "333366", "333333", "333300", "3300FF", "3300CC", "330099", "330066", "330033", "330000", "00FFFF", "00FFCC", "00FF99", "00FF66", "00FF33", "00FF00", "00CCFF", "00CCCC", "00CC99", "00CC66", "00CC33", "00CC00", "0099FF", "0099CC", "009999", "009966", "009933", "009900", "0066FF", "0066CC", "006699", "006666", "006633", "006600", "0033FF", "0033CC", "003399", "003366", "003333", "003300", "0000FF", "0000CC", "000099", "000066", "000033", "000000"];

  $(function() {
    var my_pallet, mycanvas;
    my_pallet = new Pallet(pallet_web_216);
    return mycanvas = new Arthamster("example", 700, 453);
  });

}).call(this);
