$(document).on('shown.bs.collapse', '#effective-search-icon-form', function () {
  $("#effective-search-input").focus();
});

$(document).on('hidden.bs.collapse', '#effective-search-icon-form', function () {
  $("#effective-search-input").blur();
});
