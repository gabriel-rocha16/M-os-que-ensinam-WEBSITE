# app/models/candidato.rb
class Candidato < ApplicationRecord
  belongs_to :usuario

  # Associações N:N com as Join Tables
  has_and_belongs_to_many :cursos
  has_and_belongs_to_many :beneficios
  has_and_belongs_to_many :deficiencias

  # Um candidato pode enviar vários arquivos de laudo
  has_many :laudos, dependent: :destroy

  # Validações para garantir que o formulário obrigatório seja preenchido
  validates :cidade, :estado, :data_nascimento, presence: true

  # Método auxiliar para o fluxo de acessibilidade
  def pode_acessar_cursos_gratuitos?
    possui_deficiencia && deficiencias.any?
  end
end
