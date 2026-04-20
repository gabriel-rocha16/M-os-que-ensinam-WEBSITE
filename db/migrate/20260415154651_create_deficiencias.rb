class CreateDeficiencias < ActiveRecord::Migration[8.1]
  def change
    create_table :deficiencias do |t|
      t.string :descricao
      t.string :tipo

      t.timestamps
    end
  end
end
