class CreateJoinTableCandidatoCurso < ActiveRecord::Migration[8.1]
  def change
    create_join_table :candidatos, :cursos do |t|
      t.index [ :candidato_id, :curso_id ], unique: true
    end
  end
end
