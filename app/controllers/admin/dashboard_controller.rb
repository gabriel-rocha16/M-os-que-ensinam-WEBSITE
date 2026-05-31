class Admin::DashboardController < ApplicationController
  before_action :authenticate_usuario!
  before_action :verificar_gestor_ativo!

  def index
    @cursos = Curso.includes(:usuario, :matriculas).order(created_at: :desc)
    @cursos_aguardando_aprovacao = Curso.aguardando_aprovacao.order(created_at: :desc).limit(6)
    @total_alunos = Candidato.count
    @total_cursos = Curso.count
    @total_inscricoes = Matricula.count
    @total_instrutores = Instrutor.count
    @total_cursos_revisao = Curso.aguardando_aprovacao.count
    @atividades_recentes = build_atividades_recentes
    @configuracao = Configuracao.atual
  end

  def build_atividades_recentes
    atividades = []
    Usuario.order(created_at: :desc).limit(4).each do |usuario|
      atividades << {
        icon: "user",
        text: "#{usuario.nome} se cadastrou na plataforma",
        time: usuario.created_at
      }
    end

    Curso.order(updated_at: :desc).limit(4).each do |curso|
      label = if curso.publicado?
                "publicado"
      elsif curso.aguardando_aprovacao?
                "enviado para revisão"
      else
                "atualizado"
      end
      atividades << {
        icon: "book-open",
        text: "Curso \"#{curso.nome}\" #{label}",
        time: curso.updated_at
      }
    end

    atividades.sort_by { |item| item[:time] }.reverse.first(6)
  end

  def toggle_aprovacao
    config = Configuracao.atual
    config.update(aprovacao_automatica: !config.aprovacao_automatica)
    estado = config.aprovacao_automatica ? "ativada" : "desativada"
    redirect_back fallback_location: admin_dashboard_path, notice: "Aprovação automática #{estado}."
  end

  private

  def verificar_acesso_ao_painel!
    unless perfil_ativo == "gestor"
      redirect_to dashboard_gateway_path, alert: "Acesso negado"
    end
  end
end
