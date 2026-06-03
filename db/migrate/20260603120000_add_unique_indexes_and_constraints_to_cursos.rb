class AddUniqueIndexesAndConstraintsToCursos < ActiveRecord::Migration[8.0]
  def change
    # Adiciona índices únicos para prevenir cursos duplicados
    add_index :cursos, :nome, unique: true, if_not_exists: true
    add_index :cursos, :youtube_url, unique: true, if_not_exists: true, where: "youtube_url IS NOT NULL"

    # Torna usuario_id e instrutor_id NOT NULL para garantir que todo curso tenha dono
    change_column_null :cursos, :usuario_id, false
    change_column_null :cursos, :instrutor_id, false
  end
end
