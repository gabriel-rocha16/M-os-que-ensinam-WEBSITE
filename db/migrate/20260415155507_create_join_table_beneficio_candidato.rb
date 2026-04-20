class CreateJoinTableBeneficioCandidato < ActiveRecord::Migration[8.1]
  def change
    create_join_table :beneficios, :candidatos do |t|
      t.index [ :beneficio_id, :candidato_id ], unique: true
    end
  end
end
