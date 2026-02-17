# frozen_string_literal: true

# EffectiveSearchAdminSearch
# Mark your search model with include EffectiveSearchAdminSearch

module EffectiveSearchAdminSearch
  extend ActiveSupport::Concern

  module ClassMethods
    def effective_search_admin_search?; true; end
  end

  included do
    include ActiveModel::Model

    attr_accessor :current_user
    attr_accessor :view_context

    attr_accessor :term
    validates :term, length: { minimum: 1, allow_blank: true }
  end

  def to_s
    term.to_s
  end

  def per_page
    5
  end

  def present?
    term.present?
  end

  def users
    @users ||= Effective::Resource.new(current_user.class).search_any(term, columns: [:first_name, :last_name, :email])
  end

  def organizations
    @organizations ||= Effective::Resource.new(EffectiveMemberships.Organization).search_any(term, columns: [:title, :email])
  end

  def orders
    @orders ||= Effective::Resource.new(Effective::Order).search_any(term, columns: [:id])
  end

  def applicants
    @applicants = EffectiveMemberships.Applicant.where(user: users).order(created_at: :desc)
  end

  def events
    @events ||= Effective::Resource.new(Effective::Event).search_any(term, columns: [:title]).reorder(start_at: :desc)
  end

  def pages
    @pages ||= Effective::Resource.new(Effective::Page).search_any(term, columns: [:title])
  end

  def posts
    @posts ||= Effective::Resource.new(Effective::Post).search_any(term, columns: [:title]).reorder(published_start_at: :desc)
  end

  # Search and assigns the collection
  # Assigns the entire collection() if there are no search terms
  # Otherwise validate the search terms
  def search!
    @users = users()
    @orders = orders()
    @applicants = applicants()
    @organizations = organizations()
    @events = events()
    @pages = pages()
    @posts = posts()
  end

  # The paginated results
  def user_results(page: nil)
    results(users, page: page)
  end

  def order_results(page: nil)
    results(orders, page: page)
  end

  def applicant_results(page: nil)
    results(applicants, page: page)
  end

  def organization_results(page: nil)
    results(organizations, page: page)
  end

  def event_results(page: nil)
    results(events, page: page)
  end

  def page_results(page: nil)
    results(pages, page: page)
  end

  def post_results(page: nil)
    results(posts, page: page)
  end

  private

  def results(collection, page: nil)
    page = (page || 1).to_i
    offset = [(page - 1), 0].max * per_page

    collection.limit(per_page).offset(offset)
  end

end

