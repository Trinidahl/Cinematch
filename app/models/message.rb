class Message < ApplicationRecord
  acts_as_message
  belongs_to :chat

  validates :role, presence: true, inclusion: { in: %w[user assistant] }
  validates :content, presence: true
end
