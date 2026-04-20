class Instrutor < ApplicationRecord
  self.table_name = "instrutors"
  belongs_to :usuario
  has_many :cursos # Relaciona com a FK instrutor_id em Cursos

  validates :formacao_academica, presence: true
end
