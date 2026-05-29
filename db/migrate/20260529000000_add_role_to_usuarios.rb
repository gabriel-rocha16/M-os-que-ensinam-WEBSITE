class AddRoleToUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :usuarios, :role, :integer, default: 0, null: false
    add_index :usuarios, :role
  end
end
