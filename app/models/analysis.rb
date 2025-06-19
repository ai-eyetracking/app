class Analysis < ApplicationRecord
  belongs_to :project
  has_many :versions, class_name: 'AnalysisVersion', dependent: :destroy
  has_many :key_areas, dependent: :destroy

  scope :recent, ->{order(created_at: :desc)}

  enum analysis_type: { website: 0 }

  validates :name, presence: true
  
  def current_version
    versions.ordered.last
  end
  
  def latest_heatmap_data
    current_version&.heatmap_data
  end
end