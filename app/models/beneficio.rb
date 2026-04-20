class Beneficio < ApplicationRecord
  has_and_belongs_to_many :candidatos

  validates :nome, presence: true
end
