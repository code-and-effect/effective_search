$(document).on('shown.bs.collapse', '#effective-search-icon-form', function () {
  $("#effective-search-input").focus();
});

$(document).on('hidden.bs.collapse', '#effective-search-icon-form', function () {
  $("#effective-search-input").blur();
});

// Handle pagination clicks within the search results
$(document).on('click', '#admin-search-modal .page-link', function(event) {
  event.preventDefault();
  
  var $link = $(this);
  var href = $link.attr('href');
  
  // Extract the page parameter from the URL
  var pageMatch = href.match(/[?&]page=(\d+)/);
  if (!pageMatch) return;
  
  var pageNumber = pageMatch[1];
  
  // Find the closest form and update the hidden page field
  var $form = $link.closest('form');
  if ($form.length === 0) return;
  
  var $pageField = $form.find('input[name="page"]');
  if ($pageField.length === 0) return;

  // Update the page value and submit the form
  $pageField.val(pageNumber);

  $form.find("[data-load-ajax-url]").trigger('reload');
});

// Reset to page 1 when the user types in the search field
$(document).on('keyup paste', "#admin-search-modal [data-load-ajax-url]", function(event) {
  $(event.currentTarget).closest('form').find('input[name="page"]').val(1);
});

