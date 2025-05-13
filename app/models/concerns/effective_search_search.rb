# frozen_string_literal: true

# EffectiveSearchSearch
# Mark your search model with include EffectiveSearchSearch

module EffectiveSearchSearch
  extend ActiveSupport::Concern

  module ClassMethods
    def effective_search_search?; true; end
  end

  included do
    include ActiveModel::Model

    attr_accessor :current_user
    attr_accessor :view_context

    attr_accessor :term
    validates :term, length: { minimum: 3, allow_blank: true }
  end

  def to_s
    term.to_s
  end

  # Limit the search to certain searchable types. Return nil for all
  # ['Effective::Page', 'Effective::Post']
  def searchable_types
    nil
  end

  # These classes should not be searched
  def unsearchable_types
    ['Effective::Permalink', 'Effective::SearchContent']
  end

  def per_page
    24
  end

  def present?
    term.present?
  end

  # Search and assigns the collection
  # Assigns the entire collection() if there are no search terms
  # Otherwise validate the search terms
  def search!
    @search_results = build_collection()
    @search_results = @search_results.none if present? && !valid?
    @search_results
  end

  # This is Set #1 of results we display on the search page
  def search_contents
    return [] unless present?
    @search_contents ||= Effective::Resource.new(Effective::SearchContent.deep).search_any(term, columns: [:keywords])
  end

  # This is Set #2 of results we display on the search page
  def permalinks
    return [] unless present?
    @permalinks ||= Effective::Resource.new(Effective::Permalink.deep).search_any(term, columns: [:title, :summary])
  end

  # The unpaginated results of the search
  def search_results
    @search_results || []
  end

  # The paginated results
  def results(page: nil)
    page = (page || 1).to_i
    offset = [(page - 1), 0].max * per_page

    search_results.limit(per_page).offset(offset)
  end

  # View helper
  def authorized?(result)
    searchable = result.try(:searchable) || result

    return false if searchable.blank?
    return false if searchable.try(:draft?)
    return false if searchable.try(:archived?)

    if view_context.present?
      return EffectiveResources.authorized?(view_context, :show, searchable)
    end

    true
  end

  # View helper
  def title(result)
    (result.try(:searchable).try(:title) || result.try(:title) || result).to_s.html_safe
  end

  # View helper
  def path(result)
    effective_path(result) || polymorphic_path(result) || raise("unknown path for #{result.searchable_type}")
  end

  # View helper
  def body(result)
    content = (result.try(:pg_search_highlight) || result.try(:rich_text_body) || result).to_s
    scrubs.each { |pattern| content.gsub!(pattern, '') }
    content.html_safe
  end

  # Scrub the body content with these regexes
  def scrubs
    [
      /(<p>)?\[posts\scategory=\"(.*?)\"\](<\/p>)?/,
      /(<p>)?\[permalinks\stag=\"(.*?)\"\](<\/p>)?/,
      /\[picflow\s+gallery="[^"]*"\]/
    ]
  end

  protected

  # Returns an ActiveRecord collection of PgSearch::Document 
  def build_collection
    raise('expected pg_search gem') unless defined?(PgSearch)

    collection = PgSearch::Document.all

    if term.present?
      collection = PgSearch.multisearch(term)
    end

    # Restrict search to certain searchable types
    if searchable_types.present?
      collection = collection.where(searchable_type: searchable_types)
    end

    if unsearchable_types.present?
      collection = collection.where.not(searchable_type: unsearchable_types)
    end

    # Preload what we need
    collection = collection.includes(searchable: [:rich_text_body])

    # Return all the results
    collection
  end

  # Sort of a view helper. The result is passed through here
  def effective_path(result)
    class_name = result.try(:searchable_type) || result.class.name

    case class_name
    when 'Effective::Page'
      EffectivePages::Engine.routes.url_helpers.page_path(result.searchable)
    when 'Effective::Permalink'
      EffectivePages::Engine.routes.url_helpers.permalink_redirect_path(result.searchable)
    when 'Effective::Post'
      EffectivePosts::Engine.routes.url_helpers.post_path(result.searchable)
    when 'Effective::Event'
      EffectiveEvents::Engine.routes.url_helpers.event_path(result.searchable)
    when 'Effective::SearchContent'
      result.url
    end
  end

  def polymorphic_path(result)
    url_helpers = (defined?(Tenant) ? Tenant.routes : Rails.application.routes.url_helpers)
    url_helpers.try("#{result.searchable_type.underscore}_path", result.searchable)
  end

end

