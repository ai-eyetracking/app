class AnalysisVersion < ApplicationRecord
  belongs_to :analysis
  
  validates :version_number, presence: true, uniqueness: { scope: :analysis_id }
  validates :image_path, presence: true
  
  before_create :set_version_number
  
  scope :ordered, -> { order(:version_number) }
  
  private
  
  def set_version_number
    self.version_number = (analysis.versions.maximum(:version_number) || 0) + 1
  end
end
