# Provides content areas that will be displayed for specific search terms

module Effective
  class SearchContent < ActiveRecord::Base
    self.table_name = (EffectiveSearch.search_contents_table_name || :search_contents).to_s

    # For the body
    has_many_rich_texts

    has_one_attached :file
    has_one_purgable :file

    log_changes if respond_to?(:log_changes)

    effective_resource do
      title          :string
      url            :string
      keywords       :string

      timestamps
    end

    validates :title, presence: true
    validates :url, presence: true, url: true
    validates :keywords, presence: true

    validates :file, content_type: :image
    validates :file, size: { less_than: 2.megabytes }

    scope :deep, -> { with_attached_file.includes(:rich_texts) }
    scope :sorted, -> { order(:title) }

    def to_s
      title.presence || model_name.human
    end

    # As per has_many_rich_texts
    def body
      rich_text_body
    end
  end
end
