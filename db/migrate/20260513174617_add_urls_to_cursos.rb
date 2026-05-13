class AddUrlsToCursos < ActiveRecord::Migration[8.1]
  def change
    add_column :cursos, :youtube_url, :string
    add_column :cursos, :moodle_url, :string
  end
end
