require 'test_helper'

class Effective::SearchControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  tests Effective::SearchController

  setup do
    @routes = EffectiveSearch::Engine.routes

    search = EffectiveSearch.Search.new(term: 'missing')
    search.define_singleton_method(:search!) { @search_results = PgSearch::Document.none }
    @controller ||= Effective::SearchController.new
    @controller.define_singleton_method(:build_search) { search }
  end

  test 'invalid page raises record not found before rendering' do
    error = assert_raises(ActiveRecord::RecordNotFound) do
      get :index, params: { q: 'missing', page: 'invalid' }
    end

    assert_equal 'Page "invalid" is invalid', error.message
  end

  test 'page range is validated against the search results' do
    error = assert_raises(ActiveRecord::RecordNotFound) do
      get :index, params: { q: 'missing', page: 2 }
    end

    assert_equal 'Page 2 does not exist', error.message
  end
end
