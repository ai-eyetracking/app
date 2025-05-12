class Analysis < ApplicationRecord
  belongs_to :project

  scope :recent, ->{order(created_at: :desc)}

  enum analysis_type: { website: 0 }

  validates :name, presence: true
end