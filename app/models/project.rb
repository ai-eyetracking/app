class Project < ApplicationRecord
  belongs_to :user
  scope :recent, -> {order(created_at: :desc)} 
end