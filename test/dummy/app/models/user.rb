class User < ApplicationRecord
  include PgSearch::Model

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_rich_text :body
  has_rich_text :notes

  multisearchable against: [:body]
end
