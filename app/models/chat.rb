class Chat < ApplicationRecord
  belongs_to :user

  has_many :messages, dependent: :destroy
  has_many :recommendations, dependent: :destroy
  has_many :movies, through: :recommendations
end
