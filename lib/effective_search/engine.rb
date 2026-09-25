module EffectiveSearch
  class Engine < ::Rails::Engine
    engine_name 'effective_search'

    # Set up our default configuration options.
    initializer 'effective_search.defaults', before: :load_config_initializers do |app|
      eval File.read("#{config.root}/config/effective_search.rb")
    end

    initializer 'effective_search.action_text' do
      ActiveSupport.on_load(:action_text_rich_text) do
        include EffectiveSearch::ActionTextSearchIndex
      end
    end

  end
end
