class Admin::DashboardController < ApplicationController
  before_action :authenticate_usuario!
  before_action :verificar_acesso_ao_painel!

  def index
    if perfil_ativo == "gestor"
      @cursos = Curso.includes(:usuario, :matriculas).order(created_at: :desc)
      @total_alunos_pendentes = Candidato.pendente.count
      @total_cursos_revisao = Curso.aguardando_aprovacao.count
      @total_instrutores = Instrutor.count
    elsif perfil_ativo == "instrutor"
      @cursos = current_usuario.cursos.order(created_at: :desc)
    end
  end

  def toggle_aprovacao
    config = Configuracao.atual
    config.update(aprovacao_automatica: !config.aprovacao_automatica)
    estado = config.aprovacao_automatica ? "ativada" : "desativada"
    redirect_back fallback_location: admin_dashboard_path, notice: "Aprovação automática #{estado}."
  end

  private

  def verificar_acesso_ao_painel!
    unless %w[gestor instrutor].include?(perfil_ativo)
      redirect_to dashboard_gateway_path, alert: "Acesso negado"
    end
  end
end
