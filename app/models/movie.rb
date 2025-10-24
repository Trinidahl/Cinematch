class Movie < ApplicationRecord
  has_many :recommendations
  has_many :chats, through: :recommendations
end
