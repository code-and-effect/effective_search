module EffectiveSearch
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      desc 'Creates an EffectiveSearch initializer in your application.'

      source_root File.expand_path('../../templates', __FILE__)

      def self.next_migration_number(dirname)
        if not ActiveRecord::Base.timestamped_migrations
          Time.new.utc.strftime("%Y%m%d%H%M%S")
        else
          '%.3d' % (current_migration_number(dirname) + 1)
        end
      end

      def copy_initializer
        template ('../' * 3) + 'config/effective_search.rb', 'config/initializers/effective_search.rb'
      end

      def create_migration_file
        @search_table_name  = ':' + EffectiveSearch.search_table_name.to_s

        migration_template ('../' * 3) + 'db/migrate/101_create_effective_search.rb', 'db/migrate/create_effective_search.rb'
      end

    end
  end
end
