class RemoveUniqueConstrainsFromProject < ActiveRecord::Migration[7.1]
  def change
    remove_index :projects, name: "index_projects_on_user_id_and_title"
    add_index :projects, [:user_id, :title], name: "index_projects_on_user_id_and_title", unique: false
  end
end
