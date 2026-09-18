require 'test_helper'

class Effective::SearchControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  tests Effective::SearchController

  setup do
    @routes = EffectiveSearch::Engine.routes

    search = EffectiveSearch.Search.new(term: 'missing')
    search.define_singleton_method(:search!) { @search_results = FakeRelation.new([]) }
    @controller ||= Effective::SearchController.new
    @controller.define_singleton_method(:build_search) { search }
  end

  FakeRelation = Struct.new(:records) do
    def limit(_value) = self
    def offset(_value) = self
    def with_pg_search_highlight = self
    def load = self
    def to_a = records
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

  test 'search page title is not marked as HTML safe' do
    search = EffectiveSearch.Search.new(term: '<script>alert(1)</script>')
    search.define_singleton_method(:search!) { @search_results = FakeRelation.new([]) }
    @controller.define_singleton_method(:build_search) { search }
    @controller.define_singleton_method(:default_render) {}

    get :index

    page_title = @controller.view_assigns.fetch('page_title')
    assert_equal 'Search results for ‘<script>alert(1)</script>’', page_title
    assert_not page_title.html_safe?
  end
end
