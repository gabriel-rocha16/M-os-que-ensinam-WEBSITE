class CreateLaudos < ActiveRecord::Migration[8.1]
  def change
    create_table :laudos do |t|
      t.references :candidato, null: false, foreign_key: true
      t.text :descricao
      t.string :url_arquivo
      t.datetime :criado_em

      t.timestamps
    end
  end
end
