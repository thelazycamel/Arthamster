#to compile the coffeeScript, squash and watch:
#coffee --join scripts/arthamster.js -cw lib/

$ ->
  my_palette = new Palette(pallet_web_216)
  mycanvas = new Arthamster("example", 700, 453)
