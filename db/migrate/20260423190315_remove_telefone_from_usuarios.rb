class RemoveTelefoneFromUsuarios < ActiveRecord::Migration[8.1]
  def change
    remove_column :usuarios, :telefone, :string
  end
end
