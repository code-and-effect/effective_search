require 'test_helper'

class EffectiveSearchHelperTest < ActionView::TestCase
  test 'renders previous and next links while preserving query parameters' do
    html = effective_search_paginate(page: 2, has_next_page: true, url: '/search?q=term')

    assert_includes html, 'page=1&amp;q=term'
    assert_includes html, 'page=3&amp;q=term'
    assert_includes html, 'rel="prev"'
    assert_includes html, 'rel="next"'
  end

  test 'does not render pagination for a single page' do
    assert_nil effective_search_paginate(page: 1, has_next_page: false, url: '/search?q=term')
  end
end
