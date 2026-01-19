module Admin
  class SearchController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_search) }

    include Effective::CrudController

    def index
      EffectiveResources.authorize!(self, :index, EffectiveSearch.AdminSearch)

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
      search = EffectiveSearch.AdminSearch.new()
      search.assign_attributes(search_params.select { |k, _| search.respond_to?("#{k}=") })
      search.assign_attributes(current_user: current_user, view_context: view_context)
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
