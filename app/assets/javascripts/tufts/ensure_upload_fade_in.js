Blacklight.onLoad(function() {
  $('#fileupload').bind('fileuploadadd', function (e, data) {
    $('.template-upload').addClass('in');
  });
});
