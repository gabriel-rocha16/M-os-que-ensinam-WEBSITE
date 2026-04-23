class AddUsuarioToCursos < ActiveRecord::Migration[8.1]
  def change
    add_reference :cursos, :usuario, null: true, foreign_key: true
  end
end
