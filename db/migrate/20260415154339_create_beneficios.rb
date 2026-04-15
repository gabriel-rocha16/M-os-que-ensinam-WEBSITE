class CreateBeneficios < ActiveRecord::Migration[8.1]
  def change
    create_table :beneficios do |t|
      t.string :nome
      t.text :descricao

      t.timestamps
    end
  end
end
