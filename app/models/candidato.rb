# app/models/candidato.rb
class Candidato < ApplicationRecord
  belongs_to :usuario

  # Associações N:N com as Join Tables
  has_many :matriculas, dependent: :destroy
  has_many :cursos, through: :matriculas
  has_and_belongs_to_many :beneficios
  has_and_belongs_to_many :deficiencias

  # Status da validação de laudos
  enum :status, { pendente: 0, validado: 1, rejeitado: 2 }, default: :pendente

  has_many_attached :laudos_medicos
  has_one_attached :curriculo

  attr_writer :beneficios_lista, :outro_beneficio, :deficiencias_lista

  def beneficios_lista
    @beneficios_lista ||= beneficios.distinct.pluck(:nome)
  end

  def deficiencias_lista
    @deficiencias_lista ||= deficiencias.distinct.pluck(:tipo)
  end

  def outro_beneficio
    padroes = [ "Aposentadoria por Invalidez", "Auxílio-Doença", "Auxílio Brasil", "Bolsa Família", "Pensão por Morte", "BPC/LOAS\n(Benefício de Prestação Continuada)" ]
    @outro_beneficio ||= beneficios.where.not(nome: padroes).pluck(:nome).first
  end

  before_validation :limpar_telefone
  before_validation :processar_listas
  before_create :verificar_aprovacao_automatica

  validates :laudos_medicos, attached: true,
                             content_type: [ "application/pdf", "image/jpeg", "image/png" ],
                             size: { less_than: 5.megabytes },
                             limit: { min: 1, max: 3 }

  # Validações para garantir que o formulário obrigatório seja preenchido
  validates :cidade, :estado, :data_nascimento, :escolaridade, :telefone, presence: true
  validate :deve_ter_deficiencia
  validates :telefone, format: { with: /\A\d+\z/, message: "deve conter apenas números" }, if: -> { telefone.present? }
  validates :curriculo, attached: true,
                        content_type: [ "application/pdf", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document" ],
                        size: { less_than: 5.megabytes }
  validates :trabalhando, :possui_beneficio, inclusion: { in: [ true, false ] }

  # Regra de Negócio: Exclusividade PcD
  validates :possui_deficiencia, acceptance: { accept: [ true, "1", 1 ], message: "deve ser confirmada. Esta plataforma é exclusiva para pessoas com deficiência." }

  # Método auxiliar para o fluxo de acessibilidade
  def pode_acessar_cursos_gratuitos?
    validado? && possui_deficiencia
  end

  def telefone_formatado
    return "" if telefone.blank?
    if telefone.length == 13 && telefone.start_with?("55")
      "+#{telefone[0..1]} (#{telefone[2..3]}) #{telefone[4..8]}-#{telefone[9..12]}"
    elsif telefone.length == 12 && telefone.start_with?("55")
      "+#{telefone[0..1]} (#{telefone[2..3]}) #{telefone[4..7]}-#{telefone[8..11]}"
    else
      "+#{telefone}"
    end
  end

  private

  def deve_ter_deficiencia
    # Verifica se o usuário selecionou alguma deficiência (HABTM) ou preencheu "Outros..."
    if deficiencias.blank? && tipo_deficiencia.blank?
      errors.add(:base, "Você deve selecionar pelo menos uma deficiência ou descrever sua deficiência no campo 'Outros...'")
    end
  end

  def limpar_telefone
    if telefone.present?
      self.telefone = telefone.gsub(/\D/, "")
      # Assumir DDI do Brasil (55) se o usuário digitou apenas o número local
      if telefone.length == 10 || telefone.length == 11
        self.telefone = "55#{telefone}"
      end
    end
  end

  def verificar_aprovacao_automatica
    if Configuracao.atual.aprovacao_automatica?
      self.status = :validado
    end
  end

  def processar_listas
    if instance_variable_defined?(:@beneficios_lista)
      lista_ben = Array(@beneficios_lista).map(&:to_s).map(&:strip).reject { |b| b == "Outros..." || b.blank? }.uniq
      lista_ben << self.outro_beneficio if self.outro_beneficio.present?
      lista_ben.uniq!

      self.beneficios = lista_ben.map do |nome|
        Beneficio.find_or_create_by!(nome: nome) do |b|
          b.descricao = nome
        end
      end
    end

    if instance_variable_defined?(:@deficiencias_lista)
      # Processa APENAS as deficiências das CHECKBOXES (exclui "Outros...")
      lista_def = Array(@deficiencias_lista).map(&:to_s).map(&:strip).reject { |d| d == "Outros..." || d.blank? }.uniq

      # Cria associações HABTM com as deficiências pré-definidas
      self.deficiencias = lista_def.map do |nome|
        begin
          Deficiencia.create_with(descricao: nome).find_or_create_by!(tipo: nome)
        rescue ActiveRecord::RecordNotUnique
          # Em caso de condição de corrida, recupera o registro já existente
          Deficiencia.where("lower(tipo) = ?", nome.to_s.downcase).first!
        end
      end

      # O campo 'tipo_deficiencia' é APENAS para o texto livre do "Outros..."
      # Não deve conter as deficiências pré-definidas (isso é duplicação!)
      self.tipo_deficiencia = self.tipo_deficiencia.to_s.strip.presence
    end
  end
end
