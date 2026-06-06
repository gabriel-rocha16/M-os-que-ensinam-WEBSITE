class Deficiencia < ApplicationRecord
  has_and_belongs_to_many :candidatos

  before_validation :normalize_fields

  validates :descricao, :tipo, presence: true
  validates :tipo, uniqueness: { case_sensitive: false }

  private

  def normalize_fields
    self.tipo = tipo.to_s.strip.presence
    self.descricao = descricao.to_s.strip.presence
  end
end
