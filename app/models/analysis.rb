class Analysis < ApplicationRecord
  belongs_to :project

  enum type: { website: 0 }

  validates :name, presence: true
end