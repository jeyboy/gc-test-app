$(document).ready(function(){

	if ($('#file-uploader').exists()) {
		createUploader();
	}

	attachClickToPhotos();
});

function createUploader() {
	var uploader = new qq.FileUploader({
		element: $('#file-uploader').get(0),
		multiple: false,
		action: '/profile/logos',
    uploadButtonText: 'Browse for file',
    cancelButtonText: 'Cancel upload',
		params: {	authenticity_token: $('input[name=authenticity_token]').val()	},
		onComplete: function(id, fileName, responseJSON){
			resetJcropImage(responseJSON);
			updatePhotosList(responseJSON);
		}
	});
	uploader._button._options.onChange = function(input) {
		$("ul.qq-upload-list").html("");
		uploader._onInputChange(input);
	}
}

function resetJcropImage(image) {
  // FIXME: onImageClick -- destroy Jcrop, change the image, reload Jcrop
  $('.crop_container img').prop('src', image.url).css({width: image.w, height: image.h});
  crop_form.prop('action', crop_form_action.replace("%1", image.id));
}

function updatePhotosList(image) {
	var img = $("<img/>").attr("src", image.thumb_url);
	var a = $("<a></a>")
					.attr("href", "#")
					.attr("data-url", image.url)
					.attr("data-width", image.w)
					.attr("data-height", image.h)
                    .attr("data-id", image.id)
					.append(img);
	var li = $("<li></li>").css("display", "none").append(a);
	$(".photos ul").append(li)
	li.show(800);
	attachClickToPhotos();
}

var crop_form = $('#crop_form');
var crop_form_action = crop_form.prop('action');

function attachClickToPhotos() {
  $(".photos ul li a").unbind('click');
  $(".photos ul li a").bind('click', function(event) {
    var image = new Object();
    image.url = $(this).data("url");
    image.w = $(this).data("width");
    image.h = $(this).data("height");
    image.id = $(this).data("id");
    resetJcropImage(image);
    event.preventDefault();
  });
}