class AddUniqueIndexesToBeneficiosAndDeficiencias < ActiveRecord::Migration[8.1]
  def change
    add_index :beneficios, :nome, unique: true, if_not_exists: true
    add_index :deficiencias, :tipo, unique: true, if_not_exists: true
  end
end
