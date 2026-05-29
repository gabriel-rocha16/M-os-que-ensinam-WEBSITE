class DashboardsController < ApplicationController
  before_action :verificar_admin!, only: [ :admin ]
  before_action :verificar_aluno_ativo!, only: [ :aluno ]
  before_action :verificar_instrutor_ativo!, only: [ :instrutor ]

  def admin
  end

  def aluno
  end

  def instrutor
    @cursos = current_usuario.cursos.order(created_at: :desc)
  end

  private

  def verificar_aluno_ativo!
    unless perfil_ativo == "aluno"
      redirect_back fallback_location: root_path, alert: "Modo Aluno é necessário para acessar esta área. Alterne o seu perfil."
    end
  end
end
