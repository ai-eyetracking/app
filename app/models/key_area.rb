class KeyArea < ApplicationRecord
  belongs_to :analysis
  
  validates :name, presence: true
  validates :x, :y, :width, :height, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  
  # Common label names that will be suggested in the UI
  COMMON_LABELS = [
    'Logo',
    'Main Menu',
    'Hero Section',
    'CTA Button',
    'Footer'
  ].freeze
  
  # Convert pixel coordinates to percentages based on image dimensions
  def self.pixels_to_percentages(pixel_coords, image_width, image_height)
    {
      x: (pixel_coords[:x].to_f / image_width * 100).round(2),
      y: (pixel_coords[:y].to_f / image_height * 100).round(2),
      width: (pixel_coords[:width].to_f / image_width * 100).round(2),
      height: (pixel_coords[:height].to_f / image_height * 100).round(2)
    }
  end
  
  # Convert percentages back to pixels for display
  def to_pixels(image_width, image_height)
    {
      x: (x * image_width / 100).round,
      y: (y * image_height / 100).round,
      width: (width * image_width / 100).round,
      height: (height * image_height / 100).round
    }
  end
end
