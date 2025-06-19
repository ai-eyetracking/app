class CreateAnalysisVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :analysis_versions do |t|
      t.references :analysis, null: false, foreign_key: true
      t.integer :version_number, null: false
      t.string :image_path, null: false
      t.json :heatmap_data
      t.json :custom_scoring
      t.text :notes

      t.timestamps
    end
    
    add_index :analysis_versions, [:analysis_id, :version_number], unique: true
  end
end
