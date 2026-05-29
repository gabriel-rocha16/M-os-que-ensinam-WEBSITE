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

    # --- 🚀 NOVAS MÉTRICAS RELEVANTES ---
    
    # Retorna um Hash ex: {"SP" => 50, "BA" => 30} ordenado do maior para o menor
    @candidatos_por_estado = Candidato.where.not(estado: [nil, ""])
                                      .group(:estado)
                                      .order('count_all DESC')
                                      .count

    # Retorna o ranking das top 5 cidades com mais candidatos
    @top_cidades = Candidato.where.not(cidade: [nil, ""])
                            .group(:cidade, :estado)
                            .order('count_all DESC')
                            .limit(5)
                            .count

    # Como você usa uma tabela NxN (has_and_belongs_to_many :deficiencias), 
    # nós contamos os registros direto da tabela de associação agrupando pelo tipo da deficiência
    @ranking_deficiencias = Deficiencia.joins(:candidatos)
                                       .group(:tipo)
                                       .order('count_all DESC')
                                       .count

    # --- 🎯 MAPEAMENTO OPERACIONAL DE BENEFÍCIOS SOCIAIS (N:N) ---

    # 1. Lista de benefícios padrões para controle
    @beneficios_alvo = [
      "Aposentadoria por Invalidez", 
      "Auxílio-Doença", 
      "Auxílio Brasil", 
      "Bolsa Família", 
      "Pensão por Morte", 
      "BPC/LOAS\n(Benefício de Prestação Continuada)"
    ]

   # 2. Busca e agrupa removendo duplicados com DISTINCT (Sem order no banco para não quebrar o SQL)
    contagem_bruta = Beneficio.joins(:candidatos)
                              .group(:nome)
                              .count('DISTINCT candidatos.id')

    # 3. Consolidação no Hash final separando os fixos e unificando os digitados
    @distribuicao_beneficios = Hash.new(0)
    nomes_digitados = []

    contagem_bruta.each do |nome_beneficio, total|
      nome_limpo = nome_beneficio.to_s.strip
      next if nome_limpo.blank?
      
      # Procura se o nome salvo bate com a lista fixa
      correspondencia = @beneficios_alvo.find { |b| b.strip.downcase == nome_limpo.downcase }

      if correspondencia
        @distribuicao_beneficios[correspondencia] += total
      else
        @distribuicao_beneficios["Outros Benefícios (Digitados)"] += total
        nomes_digitados << nome_limpo
      end
    end

    # 4. Ajuste na ordenação via Ruby (Remove zerados e joga os "Outros" sempre para baixo)
    @distribuicao_beneficios = @distribuicao_beneficios.reject { |_, v| v.zero? }

    outros_chave = "Outros Benefícios (Digitados)"
    total_outros = @distribuicao_beneficios.delete(outros_chave)

    # Ordena os benefícios conhecidos do MAIOR para o MENOR (pelo Ruby, sem chance de quebrar o SQL)
    beneficios_ordenados = @distribuicao_beneficios.sort_by { |_, v| -v }.to_h

    # Reinsere o "Outros Benefícios" apenas no final se ele possuir registros reais (sem falsificação)
    if total_outros.present? && total_outros.positive?
      beneficios_ordenados[outros_chave] = total_outros 
    end

    @distribuicao_beneficios = beneficios_ordenados

    # Define a base (100%) para a proporção das barras do gráfico na view
    @max_beneficio = @distribuicao_beneficios.values.max.to_f

    # 5. Lista limpa e sem duplicadas de quais são os outros benefícios (apenas para leitura do gestor)
    @nomes_outros_beneficios = nomes_digitados.uniq.sort
  end
end
