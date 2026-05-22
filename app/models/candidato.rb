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

<<<<<<< Updated upstream
=======
  attr_writer :beneficios_lista, :outro_beneficio, :deficiencias_lista

  def beneficios_lista
    @beneficios_lista ||= beneficios.pluck(:nome)
  end

  def deficiencias_lista
    @deficiencias_lista ||= deficiencias.pluck(:tipo)
  end

  def outro_beneficio
    padroes = ["Aposentadoria por Invalidez", "Auxílio-Doença", "Auxílio Brasil", "Bolsa Família", "Pensão por Morte", "BPC/LOAS\n(Benefício de Prestação Continuada)"]
    @outro_beneficio ||= beneficios.where.not(nome: padroes).pluck(:nome).first
  end

  # ORDEM DOS CALLBACKS CORRIGIDA: Processa os dados antes de validar presence
>>>>>>> Stashed changes
  before_validation :limpar_telefone
  before_validation :processar_listas
  before_create :verificar_aprovacao_automatica

  # Validação de Anexos
  validates :laudos_medicos, attached: true,
                             content_type: ['application/pdf', 'image/jpeg', 'image/png'],
                             size: { less_than: 5.megabytes },
                             limit: { min: 1, max: 3 }

  # Validações para garantir que o formulário obrigatório seja preenchido
  validates :cidade, :estado, :data_nascimento, :escolaridade, :telefone, presence: true
  validates :telefone, format: { with: /\A\d+\z/, message: "deve conter apenas números" }, if: -> { telefone.present? }
  
  validates :curriculo, attached: true, 
                        content_type: ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'], 
                        size: { less_than: 5.megabytes }
  
  validates :trabalhando, :possui_beneficio, inclusion: { in: [true, false] }
  
  # VALIDAÇÃO CONDICIONAL INTELIGENTE: Só exige texto se não marcou nenhum checkbox
  validates :tipo_deficiencia, presence: true, if: -> { deficiencias_lista.blank? || Array(deficiencias_lista).reject(&:blank?).empty? }

  # Regra de Negócio: Exclusividade PcD
  validates :possui_deficiencia, acceptance: { accept: [true, '1', 1], message: 'deve ser confirmada. Esta plataforma é exclusiva para pessoas com deficiência.' }

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

  def limpar_telefone
    if telefone.present?
      self.telefone = telefone.gsub(/\D/, '')
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
<<<<<<< Updated upstream
end
=======

  def processar_listas
    # Processamento de Benefícios sem acumular lixo duplicado
    if beneficios_lista.present?
      lista_ben = Array(beneficios_lista).reject { |b| b == "Outros..." || b.blank? }
      lista_ben << self.outro_beneficio if self.outro_beneficio.present?
      
      self.beneficios = lista_ben.uniq.map do |nome|
        Beneficio.find_or_create_by!(nome: nome) do |b|
          b.descricao = nome
        end
      end
    else
      self.beneficios = []
    end
    
    # Processamento de Deficiências corrigido para reescrever o campo sem duplicar strings
    if deficiencias_lista.present?
      lista_def = Array(deficiencias_lista).reject { |d| d == "Outros..." || d.blank? }
      
      self.deficiencias = lista_def.map do |nome|
        Deficiencia.find_or_create_by!(tipo: nome) do |d|
          d.descricao = nome
        end
      end

      # Sobrescreve limpando o campo de texto nativo com valores únicos
      self.tipo_deficiencia = lista_def.uniq.join(", ")
    else
      self.deficiencias = []
      self.tipo_deficiencia = nil
    end
  end
end
>>>>>>> Stashed changes
