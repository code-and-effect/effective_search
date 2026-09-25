module EffectiveSearchHelper

  def effective_search_paginate(page:, has_next_page:, url: nil)
    return unless page > 1 || has_next_page

    uri = URI(url || request.fullpath)
    query = Rack::Utils.parse_nested_query(uri.query)
    path = uri.path + '?'

    previous = content_tag(:li, class: ['page-item', ('disabled' if page <= 1)].compact.join(' ')) do
      if page > 1
        link_to('Previous', path + query.merge('page' => page - 1).to_query,
          class: 'page-link', 'aria-label': 'Previous', title: 'Previous', rel: 'prev'
        )
      else
        content_tag(:span, 'Previous', class: 'page-link', 'aria-disabled': 'true')
      end
    end

    following = content_tag(:li, class: ['page-item', ('disabled' unless has_next_page)].compact.join(' ')) do
      if has_next_page
        link_to('Next', path + query.merge('page' => page + 1).to_query,
          class: 'page-link', 'aria-label': 'Next', title: 'Next', rel: 'next'
        )
      else
        content_tag(:span, 'Next', class: 'page-link', 'aria-disabled': 'true')
      end
    end

    content_tag(:nav, class: 'd-flex justify-content-center', 'aria-label': 'Search results pages') do
      content_tag(:ul, safe_join([previous, following]), class: 'pagination')
    end
  end

  def effective_search_nav_item
    if EffectiveResources.authorized?(self, :index, EffectiveSearch.Search)
      render('effective/search/form_nav_item')
    end
  end

  def effective_search_nav_icon
    if EffectiveResources.authorized?(self, :index, EffectiveSearch.Search)
      render('effective/search/form_nav_icon')
    end
  end

  def effective_search_admin_nav_icon
    if EffectiveResources.authorized?(self, :index, EffectiveSearch.AdminSearch)
      render('admin/search/form_nav_icon')
    end
  end

end
