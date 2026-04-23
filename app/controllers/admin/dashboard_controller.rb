class Admin::DashboardController < ApplicationController
  before_action :authenticate_usuario!
  before_action :verificar_instrutor_ou_admin!

  def index
    if current_usuario.gestor.present?
      @cursos = Curso.all.order(created_at: :desc)
      @total_alunos_pendentes = Candidato.pendente.count
      @total_cursos_revisao = Curso.aguardando_aprovacao.count
      @total_instrutores = Instrutor.count
    elsif current_usuario.instrutor.present?
      @cursos = current_usuario.cursos.order(created_at: :desc)
    end
  end
end
