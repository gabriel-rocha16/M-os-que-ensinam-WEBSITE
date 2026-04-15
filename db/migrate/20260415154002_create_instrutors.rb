class CreateInstrutors < ActiveRecord::Migration[8.1]
  def change
    create_table :instrutors do |t|
      t.references :usuario, null: false, foreign_key: true, index: { unique: true }
      t.text :bio
      t.string :capacitacao
      t.string :formacao_academica

      t.timestamps
    end
  end
end
