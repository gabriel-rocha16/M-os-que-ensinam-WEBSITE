class PerfisController < ApplicationController
  skip_before_action :verificar_gestor_ativo!, raise: false
  skip_before_action :verificar_instrutor_ativo!, raise: false

  def gateway
    set_default_role

    papel = session[:active_role]
    if papel == 'gestor' || papel == 'instrutor'
      redirect_to admin_dashboard_path
    elsif papel == 'aluno'
      if current_usuario.candidato&.pendente? || current_usuario.candidato&.rejeitado?
        redirect_to candidato_path
      else
        redirect_to aluno_dashboard_path
      end
    else
      redirect_to new_candidato_path
    end
  end

  def switch
    novo_perfil = params[:role]
    if perfis_disponiveis.include?(novo_perfil)
      session[:active_role] = novo_perfil
      redirect_to dashboard_gateway_path, notice: "Perfil alterado para #{novo_perfil.capitalize}"
    else
      redirect_back fallback_location: root_path, alert: "Perfil não autorizado."
    end
  end
end
