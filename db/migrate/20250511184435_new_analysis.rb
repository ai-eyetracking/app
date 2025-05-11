class NewAnalysis < ActiveRecord::Migration[7.1]
  def change
    create_table :analyses do |t|
      t.string :name, null: false
      t.integer :type, null: false, default: 0
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
