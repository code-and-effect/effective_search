module EffectiveSearch
  class Engine < ::Rails::Engine
    engine_name 'effective_search'

    # Set up our default configuration options.
    initializer 'effective_search.defaults', before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_search.rb")
    end

  end
end
