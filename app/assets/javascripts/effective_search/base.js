$(document).on('turbolinks:load', function() { initializeSearchCollapse(); });

function initializeSearchCollapse() {
  $('#effective-search-icon-form').on('shown.bs.collapse', function () {
    $("#effective-search-input").focus()
  })

  $('#effective-search-icon-form').on('hidden.bs.collapse', function () {
    $("#effective-search-input").blur()
  })
}
