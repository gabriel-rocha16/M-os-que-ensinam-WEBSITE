class Gestor < ApplicationRecord
  belongs_to :usuario
  # O gestor não possui muitas associações diretas, pois ele consulta outras tabelas
end
