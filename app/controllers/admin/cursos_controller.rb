class Admin::CursosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :set_curso
  before_action :verificar_gestor_ativo!, only: %i[publicar rejeitar]

  def solicitar_aprovacao
    if @curso.usuario_id == current_usuario.id || current_usuario.gestor.present?
      @curso.aguardando_aprovacao!
      redirect_to admin_dashboard_path, notice: "Aprovação solicitada com sucesso. O curso agora está em revisão."
    else
      redirect_to admin_dashboard_path, alert: "Você não tem permissão para esta ação."
    end
  end

  def publicar
    @curso.publicado!
    redirect_to admin_dashboard_path, notice: "Curso publicado com sucesso!"
  end

  def rejeitar
    @curso.rascunho!
    redirect_to admin_dashboard_path, alert: "Curso rejeitado. Ele retornou para o status de rascunho."
  end

  private

  def set_curso
    @curso = Curso.find(params[:id])
  end
end
