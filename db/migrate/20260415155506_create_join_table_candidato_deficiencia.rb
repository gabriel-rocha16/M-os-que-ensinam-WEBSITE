class CreateJoinTableCandidatoDeficiencia < ActiveRecord::Migration[8.1]
  def change
    create_join_table :candidatos, :deficiencias do |t|
      t.index [ :candidato_id, :deficiencia_id ], unique: true
    end
  end
end
