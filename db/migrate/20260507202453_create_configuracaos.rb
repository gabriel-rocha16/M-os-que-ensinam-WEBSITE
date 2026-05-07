class CreateConfiguracaos < ActiveRecord::Migration[8.1]
  def change
    create_table :configuracaos do |t|
      t.boolean :aprovacao_automatica, default: false

      t.timestamps
    end
  end
end
