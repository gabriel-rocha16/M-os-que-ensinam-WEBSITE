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

  validates :laudos_medicos, attached: true,
                             content_type: ['application/pdf', 'image/jpeg', 'image/png'],
                             size: { less_than: 5.megabytes },
                             limit: { min: 1, max: 3 }

  # Validações para garantir que o formulário obrigatório seja preenchido
  validates :cidade, :estado, :data_nascimento, :escolaridade, presence: true
  validates :trabalhando, :possui_beneficio, inclusion: { in: [true, false] }
  
  # Regra de Negócio: Exclusividade PcD
  validates :possui_deficiencia, acceptance: { accept: [true, '1', 1], message: 'deve ser confirmada. Esta plataforma é exclusiva para pessoas com deficiência.' }

  # Método auxiliar para o fluxo de acessibilidade
  def pode_acessar_cursos_gratuitos?
    possui_deficiencia && deficiencias.any?
  end
end
