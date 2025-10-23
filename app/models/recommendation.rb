class Recommendation < ApplicationRecord
  belongs_to :chat
  belongs_to :movie
end
