class Chat < ApplicationRecord
  has_many :recommendations, dependent: :destroy
  has_many :movies, through: :recommendations
end
