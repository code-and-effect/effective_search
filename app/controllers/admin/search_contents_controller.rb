module Admin
  class SearchContentsController < ApplicationController
    before_action(:authenticate_user!) if defined?(Devise)
    before_action { EffectiveResources.authorize!(self, :admin, :effective_search) }

    include Effective::CrudController

    def permitted_params
      params.require(:effective_search_content).permit!
    end

  end
end
