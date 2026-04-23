class AddDeficienciaToCandidatos < ActiveRecord::Migration[8.1]
  def change
    add_column :candidatos, :tipo_deficiencia, :string
  end
end
