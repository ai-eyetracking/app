class CreateKeyAreas < ActiveRecord::Migration[7.1]
  def change
    create_table :key_areas do |t|
      t.references :analysis, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :x, precision: 5, scale: 2, null: false  # 0.00 to 100.00 (percentages)
      t.decimal :y, precision: 5, scale: 2, null: false
      t.decimal :width, precision: 5, scale: 2, null: false
      t.decimal :height, precision: 5, scale: 2, null: false

      t.timestamps
    end
  end
end
