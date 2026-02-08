$(document).on('show.bs.collapse', '#effective-search-icon-form', function () {
  var $form = $(this);
  $("#effective-search-overlay").addClass('active');

  // Fade in form: wait for browser to paint opacity:0, then transition to 1
  requestAnimationFrame(function() {
    requestAnimationFrame(function() {
      $form.css('opacity', '1');
    });
  });
});

$(document).on('shown.bs.collapse', '#effective-search-icon-form', function () {
  $(this).css('opacity', '');
  $("#effective-search-input").focus();
});

$(document).on('hide.bs.collapse', '#effective-search-icon-form', function () {
  $("#effective-search-overlay").removeClass('active');
});

$(document).on('hidden.bs.collapse', '#effective-search-icon-form', function () {
  $(this).css('opacity', '');
  $("#effective-search-input").blur();
});

$(document).on('keydown', function (e) {
  if (e.key === 'Escape' && $('#effective-search-icon-form').hasClass('show')) {
    $('#effective-search-icon-form').collapse('hide');
  }
});
