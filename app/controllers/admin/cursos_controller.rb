class Admin::CursosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :set_curso
  before_action :verificar_gestor_ativo!, only: %i[publicar rejeitar destroy]

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

  def destroy
    if @curso.matriculas.exists?
      redirect_to admin_dashboard_path, alert: "Este curso possui alunos e não pode ser excluído. Arquive-o em vez disso."
    else
      @curso.destroy
      redirect_to admin_dashboard_path, notice: "Curso excluído com sucesso."
    end
  end

  private

  def set_curso
    @curso = Curso.find(params[:id])
  end
end
