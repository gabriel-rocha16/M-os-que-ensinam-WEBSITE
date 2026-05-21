# app/models/curso.rb
class Curso < ApplicationRecord
  belongs_to :usuario, optional: true
  belongs_to :instrutor, optional: true
  has_many :matriculas, dependent: :destroy
  has_many :candidatos, through: :matriculas

  # O formulário atualmente preenche `nome` e `youtube_url`.
  # Validar os campos usados pelo formulário para evitar falhas de submissão.
  validates :nome, :area, :descricao, :youtube_url, presence: true
  enum :status, { rascunho: 0, aguardando_aprovacao: 1, publicado: 2 }

  # Escopos para facilitar a listagem do Instrutor e Gestor
  # scope :ativos, -> { where(is_ativo: true) }
  # scope :gratuitos, -> { where(valor: 0) } # Ou campo similar
end
