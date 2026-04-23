# app/models/curso.rb
class Curso < ApplicationRecord
  belongs_to :usuario, optional: true
  belongs_to :instrutor, optional: true
  has_many :matriculas, dependent: :destroy
  has_many :candidatos, through: :matriculas

  validates :nome, :area, :titulo, :descricao, :video_url, presence: true
  enum :status, { rascunho: 0, aguardando_aprovacao: 1, publicado: 2 }

  # Escopos para facilitar a listagem do Instrutor e Gestor
  # scope :ativos, -> { where(is_ativo: true) }
  # scope :gratuitos, -> { where(valor: 0) } # Ou campo similar
end
