class Deficiencia < ApplicationRecord
  has_and_belongs_to_many :candidatos

  validates :descricao, :tipo, presence: true
end
