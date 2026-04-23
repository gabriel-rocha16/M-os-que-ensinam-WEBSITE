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

  # Um candidato pode enviar vários arquivos de laudo (ActiveStorage)
  has_many_attached :laudos_medicos
  has_one_attached :curriculo

  before_validation :limpar_telefone

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
end
