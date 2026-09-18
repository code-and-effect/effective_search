# frozen_string_literal: true

module EffectiveSearch
  module ActionTextSearchIndex
    extend ActiveSupport::Concern

    included do
      after_commit :refresh_pg_search_document, on: [:create, :update, :destroy]
    end

    private

    def refresh_pg_search_document
      searchable = record
      return unless searchable&.persisted?
      return unless searchable.respond_to?(:update_pg_search_document)

      options = searchable.class.try(:pg_search_multisearchable_options)
      return unless Array(options.try(:[], :against)).map(&:to_s).include?(name.to_s)
      return if persisted? && previous_changes.exclude?('body')

      association_name = "rich_text_#{name}"

      if searchable.class.reflect_on_association(association_name)
        searchable.association(association_name).reset
      elsif searchable.class.reflect_on_association(:rich_texts)
        searchable.association(:rich_texts).reset
      end

      searchable.update_pg_search_document
    end
  end
end
