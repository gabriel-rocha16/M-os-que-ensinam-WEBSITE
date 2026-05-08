class Configuracao < ApplicationRecord
  self.table_name = "configuracaos"

  def self.atual
    first_or_create!(aprovacao_automatica: false)
  end
end
