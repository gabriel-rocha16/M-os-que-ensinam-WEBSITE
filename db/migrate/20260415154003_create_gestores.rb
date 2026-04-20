class CreateGestores < ActiveRecord::Migration[8.1]
  def change
    create_table :gestores do |t|
      t.references :usuario, null: false, foreign_key: true, index: { unique: true }
      t.string :cargo
      t.string :departamento
      t.integer :nivel_acesso
      t.date :data_admissao

      t.timestamps
    end
  end
end
