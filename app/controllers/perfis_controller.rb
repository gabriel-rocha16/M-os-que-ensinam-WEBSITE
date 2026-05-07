class PerfisController < ApplicationController
  def switch
    novo_perfil = params[:role]
    if perfis_disponiveis.include?(novo_perfil)
      session[:active_role] = novo_perfil
      
      if novo_perfil == 'gestor'
        redirect_to admin_dashboard_path, notice: "Alternado para visão de Gestor."
      elsif novo_perfil == 'instrutor'
        redirect_to admin_dashboard_path, notice: "Alternado para visão de Instrutor."
      else
        redirect_to aluno_dashboard_path, notice: "Alternado para visão de Aluno."
      end
    else
      redirect_back fallback_location: root_path, alert: "Perfil não autorizado."
    end
  end
end
