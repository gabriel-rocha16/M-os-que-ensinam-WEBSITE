class AddTelefoneToCandidatos < ActiveRecord::Migration[8.1]
  def change
    add_column :candidatos, :telefone, :string
    change_column :candidatos, :tipo_deficiencia, :text
  end
end
