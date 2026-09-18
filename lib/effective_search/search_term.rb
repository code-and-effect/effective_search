# frozen_string_literal: true

module EffectiveSearch
  module SearchTerm
    extend ActiveSupport::Concern

    MAX_LENGTH = 200

    included do
      attr_accessor :term
      validate :validate_search_term
    end

    def present?
      valid? && term.to_s.present?
    end

    private

    def validate_search_term
      value = term.to_s

      unless value.valid_encoding?
        errors.add(:term, 'must use UTF-8 encoding')
        return
      end

      return if value.blank?

      errors.add(:term, 'contains an invalid null byte') if value.include?("\0")
      errors.add(:term, :too_short, count: 3) if value.length < 3
      errors.add(:term, :too_long, count: MAX_LENGTH) if value.length > MAX_LENGTH
    end
  end
end
