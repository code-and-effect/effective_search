module EffectiveSearchHelper

  def effective_search_nav_item
    if EffectiveResources.authorized?(self, :index, EffectiveSearch.Search)
      render('effective/search/form_nav_item')
    end
  end

end
