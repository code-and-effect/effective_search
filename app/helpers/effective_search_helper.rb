module EffectiveSearchHelper

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
