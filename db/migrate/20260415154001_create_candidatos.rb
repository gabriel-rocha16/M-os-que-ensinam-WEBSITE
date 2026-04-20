class CreateCandidatos < ActiveRecord::Migration[8.1]
  def change
    create_table :candidatos do |t|
      t.references :usuario, null: false, foreign_key: true, index: { unique: true }
      t.string :cidade
      t.string :estado
      t.date :data_nascimento
      t.string :escolaridade
      t.boolean :trabalhando
      t.boolean :possui_beneficio
      t.boolean :possui_deficiencia
      t.string :curriculo_url

      t.timestamps
    end
  end
end
