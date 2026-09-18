require 'test_helper'

class SearchTest < ActiveSupport::TestCase
  test 'user factory' do
    user = build_user()
    assert user.valid?
  end

  test 'rejects unsafe search terms before building a PostgreSQL query' do
    terms = [
      "abc\xFFdef".b.force_encoding(Encoding::UTF_8),
      "abc\0def",
      'a' * (EffectiveSearch::SearchTerm::MAX_LENGTH + 1)
    ]

    terms.each do |term|
      search = EffectiveSearch.Search.new(term: term)

      assert_not search.valid?
      assert_nothing_raised { assert_empty search.search!.to_a }
    end
  end

  test 'accepts a search term at the maximum length' do
    search = EffectiveSearch.Search.new(term: 'a' * EffectiveSearch::SearchTerm::MAX_LENGTH)

    assert search.valid?
  end

end
