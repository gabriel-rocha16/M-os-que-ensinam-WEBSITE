class AddActiveRoleToUsuarios < ActiveRecord::Migration[8.1]
  def change
    add_column :usuarios, :active_role, :string

    reversible do |dir|
      dir.up do
        Usuario.reset_column_information
        Usuario.find_each do |usuario|
          next if usuario.active_role.present?

          active_role = if usuario.gestor?
                          "gestor"
          elsif usuario.role == "instrutor" && usuario.instrutor.present?
                          "instrutor"
          elsif usuario.role == "aluno" && usuario.candidato.present?
                          "aluno"
          elsif usuario.instrutor.present?
                          "instrutor"
          elsif usuario.candidato.present?
                          "aluno"
          else
                          "aluno"
          end

          usuario.update_column(:active_role, active_role)
        end
      end
    end
  end
end
