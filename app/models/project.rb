class Project < ApplicationRecord
  belongs_to :user
  has_many :analyses

  scope :recent, -> {order(created_at: :desc)} 

  validates :title, presence: true
end