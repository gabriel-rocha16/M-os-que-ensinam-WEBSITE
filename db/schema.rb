# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_23_195417) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "beneficios", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "descricao"
    t.string "nome"
    t.datetime "updated_at", null: false
  end

  create_table "beneficios_candidatos", id: false, force: :cascade do |t|
    t.bigint "beneficio_id", null: false
    t.bigint "candidato_id", null: false
    t.index ["beneficio_id", "candidato_id"], name: "index_beneficios_candidatos_on_beneficio_id_and_candidato_id", unique: true
  end

  create_table "candidatos", force: :cascade do |t|
    t.string "cidade"
    t.datetime "created_at", null: false
    t.string "curriculo_url"
    t.date "data_nascimento"
    t.string "escolaridade"
    t.string "estado"
    t.boolean "possui_beneficio"
    t.boolean "possui_deficiencia"
    t.integer "status", default: 0
    t.string "telefone"
    t.text "tipo_deficiencia"
    t.boolean "trabalhando"
    t.datetime "updated_at", null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_candidatos_on_usuario_id", unique: true
  end

  create_table "candidatos_cursos", id: false, force: :cascade do |t|
    t.bigint "candidato_id", null: false
    t.bigint "curso_id", null: false
    t.index ["candidato_id", "curso_id"], name: "index_candidatos_cursos_on_candidato_id_and_curso_id", unique: true
  end

  create_table "candidatos_deficiencias", id: false, force: :cascade do |t|
    t.bigint "candidato_id", null: false
    t.bigint "deficiencia_id", null: false
    t.index ["candidato_id", "deficiencia_id"], name: "idx_on_candidato_id_deficiencia_id_2e40d20dd5", unique: true
  end

  create_table "cursos", force: :cascade do |t|
    t.string "area"
    t.integer "carga_horaria"
    t.datetime "created_at", null: false
    t.text "descricao"
    t.bigint "instrutor_id"
    t.string "nome"
    t.integer "status", default: 0
    t.string "titulo"
    t.datetime "updated_at", null: false
    t.bigint "usuario_id"
    t.string "video_url"
    t.index ["instrutor_id"], name: "index_cursos_on_instrutor_id"
    t.index ["usuario_id"], name: "index_cursos_on_usuario_id"
  end

  create_table "deficiencias", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "descricao"
    t.string "tipo"
    t.datetime "updated_at", null: false
  end

  create_table "gestores", force: :cascade do |t|
    t.string "cargo"
    t.datetime "created_at", null: false
    t.date "data_admissao"
    t.string "departamento"
    t.integer "nivel_acesso"
    t.datetime "updated_at", null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_gestores_on_usuario_id", unique: true
  end

  create_table "instrutors", force: :cascade do |t|
    t.text "bio"
    t.string "capacitacao"
    t.datetime "created_at", null: false
    t.string "formacao_academica"
    t.datetime "updated_at", null: false
    t.bigint "usuario_id", null: false
    t.index ["usuario_id"], name: "index_instrutors_on_usuario_id", unique: true
  end

  create_table "laudos", force: :cascade do |t|
    t.bigint "candidato_id", null: false
    t.datetime "created_at", null: false
    t.datetime "criado_em"
    t.text "descricao"
    t.datetime "updated_at", null: false
    t.string "url_arquivo"
    t.index ["candidato_id"], name: "index_laudos_on_candidato_id"
  end

  create_table "matriculas", force: :cascade do |t|
    t.bigint "candidato_id", null: false
    t.boolean "concluido", default: false
    t.datetime "created_at", null: false
    t.bigint "curso_id", null: false
    t.datetime "updated_at", null: false
    t.index ["candidato_id"], name: "index_matriculas_on_candidato_id"
    t.index ["curso_id"], name: "index_matriculas_on_curso_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "cpf"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.boolean "is_ativo", default: true
    t.string "nome"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["cpf"], name: "index_usuarios_on_cpf", unique: true
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["reset_password_token"], name: "index_usuarios_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "candidatos", "usuarios"
  add_foreign_key "cursos", "instrutors"
  add_foreign_key "cursos", "usuarios"
  add_foreign_key "gestores", "usuarios"
  add_foreign_key "instrutors", "usuarios"
  add_foreign_key "laudos", "candidatos"
  add_foreign_key "matriculas", "candidatos"
  add_foreign_key "matriculas", "cursos"
end
