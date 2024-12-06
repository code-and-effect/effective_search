# Effective Search

Search posts, pages, permalinks and events.

## Getting Started

This requires Rails 6+ and Twitter Bootstrap 4 and just works with Devise.

Please first install the [effective_datatables](https://github.com/code-and-effect/effective_datatables) gem.

Please download and install the [Twitter Bootstrap4](http://getbootstrap.com)

Add to your Gemfile:

```ruby
gem 'haml'
gem 'pg_search'
gem 'effective_search'
```

Run the bundle command to install it:

```console
bundle install
```

Then run the generator:

```ruby
rails generate effective_search:install
```

The generator will install an initializer which describes all configuration options and creates a database migration.

If you want to tweak the table names, manually adjust both the configuration file and the migration now.

Then migrate the database:

```ruby
rake db:migrate
```

## Configuration

Change the `config/initializers/effective_search.rb` class name. Then you can use a custom search class:

```
module Example
  class Search
    include EffectiveSearchSearch

    def per_page
      3
    end

  end
end
```

By default it will search any `PgSearch::Document` resources.

So to add your own custom search class, add

```
include PgSearch::Model
multisearchable against: [:body]
```

to your class and it should flow through to the search automatically.

You can customize the search class `def path()` method if needed.

## Authorization

All authorization checks are handled via the effective_resources gem found in the `config/initializers/effective_resources.rb` file.

## Permissions

The permissions you actually want to define are as follows (using CanCan):

```ruby
can(:index, EffectiveSearch.Search) # The /search page
```

Each searchable result object will get run through `EffectiveResources.authorize?` before being rendered

## License

MIT License. Copyright [Code and Effect Inc.](http://www.codeandeffect.com/)

## Testing

Run tests by:

```ruby
rails test
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Bonus points for test coverage
6. Create new Pull Request
