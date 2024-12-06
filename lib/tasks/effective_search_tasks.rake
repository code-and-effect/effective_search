namespace :effective_search do

  # bundle exec rake effective_search:seed
  task seed: :environment do
    load "#{__dir__}/../../db/seeds.rb"
  end

end
