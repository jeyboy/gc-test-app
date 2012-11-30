proceedCoords = (coords) ->
  $("#crop_x").val(coords.x);
  $("#crop_y").val(coords.y);
  $("#crop_w").val(coords.w);
  $("#crop_h").val(coords.h);

cleanCoords = () ->
  $("#crop_x, #crop_y, #crop_w, #crop_h").val("");

jQuery ($) ->
  $('img.js-jcrop').Jcrop
    onChange: proceedCoords
    onSelect: proceedCoords
    onRelease: cleanCoords
    boxWidth: 310
    boxHeight: 303
