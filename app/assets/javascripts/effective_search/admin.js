// Admin search handle pagination clicks
$(document).on('click', '#effective-search-admin-modal .page-link', function(event) {
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

// Admin search close the modal when they visit a search result page
$(document).on('click', '#effective-search-admin-modal a', function(event) {
  var $link = $(event.currentTarget);
  if($link.hasClass('page-link') || $link.data('effective-search-clear')) return;

  $('#effective-search-admin-modal').modal('hide');
});

// Admin search clear button
$(document).on('click', '#effective-search-admin-modal a[data-effective-search-clear]', function(event) {
  event.preventDefault();

  var $form = $(event.currentTarget).closest('form')

  $form.trigger('reset');
  $form.find('#effective-search-results').html('');
  $form.find('input[name="page"]').val(1);
  $form.find('input[name="q[term]"]').focus();
});

// Admin search reset to page 1 when search term changes
$(document).on('keyup paste', "#effective-search-admin-modal [data-load-ajax-url]", function(event) {
  var $form = $(event.currentTarget).closest('form')
  $form.find('input[name="page"]').val(1);
});

// Prevent form submission on Enter key press
$(document).on('keydown keyup', "#effective-search-admin-modal form", function(event) {
  if(event.key === 'Enter') { event.preventDefault(); }
});

// Auto focus the search input when the modal is shown
$(document).on('shown.bs.modal', '#effective-search-admin-modal', function () {
  $(".effective-search-admin").find('input[type="search"]').first().focus();
});

