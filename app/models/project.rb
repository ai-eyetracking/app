class Project < ApplicationRecord
  belongs_to :user
  scope :recent, -> {order(created_at: :desc)} 

  validates :title, presence: true, uniqueness: { scope: :user_id }
end