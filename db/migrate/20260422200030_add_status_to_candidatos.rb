class AddStatusToCandidatos < ActiveRecord::Migration[8.1]
  def change
    add_column :candidatos, :status, :integer, default: 0
  end
end
