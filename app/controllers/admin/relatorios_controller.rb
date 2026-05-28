class Admin::RelatoriosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :verificar_gestor_ativo!

  def index
    @total_alunos = Candidato.count
    @total_instrutores = Instrutor.count
    @total_cursos = Curso.count
    @cursos_publicados = Curso.publicado.count
    @cursos_pendentes = Curso.aguardando_aprovacao.count
    @total_inscricoes = Matricula.count
    @conclusoes = Matricula.where(concluido: true).count
    @taxa_conclusao = if @total_inscricoes.positive?
                        (@conclusoes.to_f / @total_inscricoes * 100).round(1)
    else
                        0
    end
    @usuarios_30_dias = Usuario.where("created_at >= ?", 30.days.ago).count
    @usuarios_60_dias_anteriores = Usuario.where(created_at: (60.days.ago...30.days.ago)).count
    @crescimento_mensal = if @usuarios_60_dias_anteriores.positive?
                            ((@usuarios_30_dias - @usuarios_60_dias_anteriores) / @usuarios_60_dias_anteriores.to_f * 100).round(1)
    else
                            @usuarios_30_dias.positive? ? 100 : 0
    end
  end
end
