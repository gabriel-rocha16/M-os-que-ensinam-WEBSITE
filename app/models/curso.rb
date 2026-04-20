# app/models/curso.rb
class Curso < ApplicationRecord
  belongs_to :instrutor
  has_and_belongs_to_many :candidatos

  validates :nome, :area, presence: true

  # Escopos para facilitar a listagem do Instrutor e Gestor
  # scope :ativos, -> { where(is_ativo: true) }
  # scope :gratuitos, -> { where(valor: 0) } # Ou campo similar
end
