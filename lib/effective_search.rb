require 'effective_resources'
require 'effective_search/engine'
require 'effective_search/version'

module EffectiveSearch

  def self.config_keys
    [:search_class_name, :authenticate_user, :layout]
  end

  include EffectiveGem

  def self.Search
    search_class_name&.constantize || Effective::Search
  end

  def self.authenticate_user?
    authenticate_user == true
  end

end
