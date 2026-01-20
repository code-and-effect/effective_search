require 'effective_resources'
require 'effective_search/engine'
require 'effective_search/version'

module EffectiveSearch

  def self.config_keys
    [:search_class_name, :admin_search_class_name, :search_contents_table_name, :authenticate_user, :layout]
  end

  include EffectiveGem

  def self.Search
    search_class_name&.constantize || Effective::Search
  end

  def self.AdminSearch
    admin_search_class_name&.constantize || Effective::AdminSearch
  end

  def self.authenticate_user?
    authenticate_user == true
  end

end
