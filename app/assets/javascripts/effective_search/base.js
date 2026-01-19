$(document).on('shown.bs.collapse', '#effective-search-icon-form', function () {
  $("#effective-search-input").focus();
});

$(document).on('hidden.bs.collapse', '#effective-search-icon-form', function () {
  $("#effective-search-input").blur();
});

$(document).on('show.bs.modal', '#admin-search-modal', function (e) {
  console.log("laoding")

  var $iframe = $(this).find('iframe[name="admin-search-frame"]');
  
  // Only load the iframe if it hasn't been loaded yet
  if (!$iframe.attr('src') && $iframe.data('src')) {
    console.log("LOADING")

    $iframe.attr('src', $iframe.data('src'));
  }
});


