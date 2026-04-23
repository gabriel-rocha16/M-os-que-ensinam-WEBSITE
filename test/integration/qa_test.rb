require "test_helper"
require "cpf_cnpj"

class QaTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = Usuario.create!(nome: "Admin", email: "admin2@maos.com", cpf: CPF.generate, password: "password123")
    Gestor.create!(usuario: @admin, cargo: "Admin", departamento: "TI", nivel_acesso: 1, data_admissao: Date.today)

    @aluno = Usuario.create!(nome: "Aluno", email: "aluno2@teste.com", cpf: CPF.generate, password: "password123")
    @aluno.create_candidato!(cidade: "SP", estado: "SP", data_nascimento: "1990-01-01", escolaridade: "Ensino Médio", trabalhando: false, possui_beneficio: false, possui_deficiencia: false)

    @curso = Curso.create!(nome: "Curso Test", area: "Tech", titulo: "Title", descricao: "Desc", video_url: "url", status: :publicado)
  end

  test "admin dashboard requires authentication" do
    get admin_dashboard_path
    assert_redirected_to new_usuario_session_path
    puts "✅ Rota admin/dashboard protegida contra deslogados."
  end

  test "aluno cannot access new curso page" do
    sign_in @aluno
    get new_curso_path
    assert_redirected_to root_path
    puts "✅ Aluno impedido de acessar Cursos#new."
  end

  test "login redirects to correct dashboard" do
    post usuario_session_path, params: { usuario: { login: @aluno.email, password: 'password123' } }
    assert_redirected_to aluno_dashboard_path
    puts "✅ Redirecionamento de login para Dashboard de Aluno ok."
  end

  test "invalid cpf is blocked" do
    u = Usuario.new(nome: "Invasor", email: "hacker@hacker.com", cpf: "000.000.000-00", password: "password123")
    assert_not u.save
    puts "✅ CPF inválido bloqueado com sucesso pelo model."
  end

  test "matricula logic prevents duplication" do
    sign_in @aluno
    
    # Primeira matricula
    assert_difference '@aluno.candidato.matriculas.count', 1 do
      post matricular_curso_path(@curso)
    end
    
    # Tentativa de matricula duplicada
    assert_no_difference '@aluno.candidato.matriculas.count' do
      post matricular_curso_path(@curso)
    end
    puts "✅ Lógica de matrícula cria registro e impede duplicidade em chamadas consecutivas."
  end
end
