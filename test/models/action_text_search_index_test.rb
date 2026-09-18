require 'test_helper'

class ActionTextSearchIndexTest < ActiveSupport::TestCase
  test 'direct rich text updates refresh the multisearch document' do
    user = create_user!
    user.update!(body: 'Original searchable body')

    user.rich_text_body.update!(body: 'Updated searchable body')

    assert_includes user.pg_search_document.reload.content, 'Updated searchable body'
  end

  test 'changes to a rich text field outside against do not refresh the multisearch document' do
    user = create_user!
    user.update!(body: 'Searchable body')
    user.update!(notes: 'Original notes')
    user.pg_search_document.update!(content: 'unchanged marker')

    user.rich_text_notes.update!(body: 'Unrelated notes')

    assert_equal 'unchanged marker', user.pg_search_document.reload.content
  end
end
