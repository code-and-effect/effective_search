class CreateEffectiveSearch < ActiveRecord::Migration[7.0]
  def up
    # PgSearch trigram extension
    if defined?(Postgres)
      enable_extension('pg_trgm') unless extension_enabled?('pg_trgm')
    end

    # PgSearch multisearch table
    create_table :pg_search_documents, if_not_exists: true do |t|
      t.text :content
      t.belongs_to :searchable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end

  def down
    # PgSearch trigram extension
    if defined?(Postgres)
      disable_extension('pg_trgm') if extension_enabled?('pg_trgm')
    end

    # PgSearch multisearch table
    drop_table :pg_search_documents, if_exists: true
  end
end
