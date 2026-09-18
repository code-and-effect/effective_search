class UpgradeEffectiveSearchZeroEight < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def up
    return unless connection.adapter_name == 'PostgreSQL'

    unless column_exists?(:pg_search_documents, :search_vector)
      execute(<<~SQL.squish)
        ALTER TABLE pg_search_documents
        ADD COLUMN search_vector tsvector
        GENERATED ALWAYS AS (
          to_tsvector('simple'::regconfig, coalesce(content, ''::text))
        ) STORED
      SQL
    end

    add_index(
      :pg_search_documents,
      :search_vector,
      using: :gin,
      algorithm: :concurrently,
      if_not_exists: true
    )
  end

  def down
    return unless connection.adapter_name == 'PostgreSQL'

    remove_index(
      :pg_search_documents,
      :search_vector,
      algorithm: :concurrently,
      if_exists: true
    )

    remove_column(:pg_search_documents, :search_vector) if column_exists?(:pg_search_documents, :search_vector)
  end
end
