# frozen_string_literal: true

Rails.application.routes.draw do
  mount EffectiveSearch::Engine => '/', as: 'effective_search'
end

EffectiveSearch::Engine.routes.draw do
  # Public routes
  scope module: 'effective' do
    match '/search', to: 'search#index', via: [:get], as: :search
  end

  namespace :admin do
    match '/search', to: 'search#index', via: [:get], as: :search
    resources :search_contents, except: [:show]
  end

end
