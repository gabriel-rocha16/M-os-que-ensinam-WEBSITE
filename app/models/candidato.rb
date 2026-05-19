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

  attr_accessor :beneficios_lista, :outro_beneficio, :deficiencias_lista

  before_validation :limpar_telefone
  before_create :verificar_aprovacao_automatica
  before_save :processar_listas

  validates :laudos_medicos, attached: true,
                             content_type: ['application/pdf', 'image/jpeg', 'image/png'],
                             size: { less_than: 5.megabytes },
                             limit: { min: 1, max: 3 }

  # Validações para garantir que o formulário obrigatório seja preenchido
  validates :cidade, :estado, :data_nascimento, :escolaridade, :telefone, :tipo_deficiencia, presence: true
  validates :telefone, format: { with: /\A\d+\z/, message: "deve conter apenas números" }, if: -> { telefone.present? }
  validates :curriculo, attached: true, 
                        content_type: ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'], 
                        size: { less_than: 5.megabytes }
  validates :trabalhando, :possui_beneficio, inclusion: { in: [true, false] }
  
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

  def processar_listas
    if beneficios_lista.present?
      lista_ben = Array(beneficios_lista).reject { |b| b == "Outros..." || b.blank? }
      lista_ben << self.outro_beneficio if self.outro_beneficio.present?
      
      self.beneficios = lista_ben.map do |nome|
        Beneficio.find_or_create_by!(nome: nome) do |b|
          b.descricao = nome
        end
      end
    end
    
    if deficiencias_lista.present?
      lista_def = Array(deficiencias_lista).reject { |d| d == "Outros..." || d.blank? }
      
      self.deficiencias = lista_def.map do |nome|
        Deficiencia.find_or_create_by!(tipo: nome) do |d|
          d.descricao = nome
        end
      end

      # Salvar também no campo texto nativo para retrocompatibilidade
      lista_texto = lista_def.dup
      lista_texto << self.tipo_deficiencia if self.tipo_deficiencia.present?
      self.tipo_deficiencia = lista_texto.join(", ") if lista_texto.any?
    end
  end
end
