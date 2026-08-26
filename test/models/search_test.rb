require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  INVALID_PAGES = ['0', '-1', '03', '3d3rfff', 0, -1, [], {}].freeze

  test 'user factory' do
    user = build_user()
    assert user.valid?
  end

  test 'public results paginate canonical positive page numbers' do
    search = public_search()

    assert_equal 24, search.results(page: 2).offset_value
    assert_equal 48, search.results(page: '3').offset_value
  end

  test 'public results default nil and empty page numbers to the first page' do
    search = public_search()

    assert_equal 0, search.results(page: nil).offset_value
    assert_equal 0, search.results(page: '').offset_value
  end

  test 'public results reject noncanonical page numbers' do
    search = public_search()

    INVALID_PAGES.each do |page|
      assert_raises(ActiveRecord::RecordNotFound) { search.results(page: page) }
    end
  end

  test 'admin results paginate canonical positive page numbers' do
    search = admin_search()

    assert_equal 5, search.user_results(page: 2).offset_value
    assert_equal 10, search.user_results(page: '3').offset_value
  end

  test 'admin results default nil and empty page numbers to the first page' do
    search = admin_search()

    assert_equal 0, search.user_results(page: nil).offset_value
    assert_equal 0, search.user_results(page: '').offset_value
  end

  test 'admin results reject noncanonical page numbers' do
    search = admin_search()

    INVALID_PAGES.each do |page|
      assert_raises(ActiveRecord::RecordNotFound) { search.user_results(page: page) }
    end
  end

  private

  def public_search
    Effective::Search.new.tap do |search|
      search.instance_variable_set(:@search_results, User.all)
    end
  end

  def admin_search
    Effective::AdminSearch.new.tap do |search|
      search.instance_variable_set(:@users, User.all)
    end
  end
end
