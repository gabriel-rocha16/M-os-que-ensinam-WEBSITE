class Admin::CursosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :verificar_gestor_ativo!
  before_action :set_curso, only: %i[publicar rejeitar destroy]

  def index
    @status = params[:status].to_s
    @cursos = Curso.includes(:usuario, :instrutor, :matriculas).order(created_at: :desc)
    @cursos = case @status
    when "publicado" then @cursos.publicado
    when "aguardando_aprovacao" then @cursos.aguardando_aprovacao
    when "rascunho" then @cursos.rascunho
    else @cursos
    end
  end

  def publicar
    @curso.publicado!
    redirect_to admin_cursos_path(status: "aguardando_aprovacao"), notice: "Curso publicado com sucesso!"
  end

  def rejeitar
    @curso.rascunho!
    redirect_to admin_cursos_path(status: "aguardando_aprovacao"), alert: "Curso rejeitado. Ele retornou para o status de rascunho."
  end

  def destroy
    if @curso.matriculas.exists?
      redirect_to admin_cursos_path(status: "aguardando_aprovacao"), alert: "Este curso possui alunos e não pode ser excluído. Arquive-o em vez disso."
    else
      @curso.destroy
      redirect_to admin_cursos_path, notice: "Curso excluído com sucesso."
    end
  end

  private

  def set_curso
    @curso = Curso.find(params[:id])
  end
end
