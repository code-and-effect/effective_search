module Effective
  class SearchController < ApplicationController
    if defined?(Devise)
      before_action(:authenticate_user!, if: -> { EffectiveSearch.authenticate_user? })
    end

    include Effective::CrudController

    def index
      EffectiveResources.authorize!(self, :index, EffectiveSearch.Search)

      # But more often we do a full membership directory search screen
      @search = build_search
      @search.search!

      if @search.present?
        @page_title = "Search results for &lsquo;#{@search}&rsquo;".html_safe
      else
        @page_title = "Search"
      end
    end

    def build_search
      search = EffectiveSearch.Search.new(search_params)
      search.current_user = current_user
      search.view_context = view_context
      search
    end

    def search_params
      return {} unless params[:q].present?

      if params[:q].respond_to?(:to_h)      # From the search form
        params.require(:q).permit!
      else
        { term: params.permit(:q).fetch(:q) }   # From the url /directory?q=asdf
      end
    end

  end
end
