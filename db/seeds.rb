require 'cpf_cnpj'

puts "Limpando banco de dados..."
Configuracao.destroy_all
Usuario.destroy_all
Curso.destroy_all # <--- Adicionado
Candidato.destroy_all

puts "Inicializando Configuração..."
Configuracao.atual

puts "Criando Gestor Admin..."
admin_cpf = CPF.generate
admin = Usuario.create!(
  nome: "Admin Gestor",
  email: "admin@maos.com",
  cpf: admin_cpf,
  password: "password123",
  password_confirmation: "password123"
)
Gestor.create!(usuario: admin, cargo: "Administrador", departamento: "Diretoria", nivel_acesso: 1, data_admissao: Date.today)
puts "Gestor criado! Email: admin@maos.com | CPF: #{admin_cpf} | Senha: password123"

puts "Criando Candidatos de teste..."
candidato1_cpf = CPF.generate
user1 = Usuario.create!(
  nome: "João Silva",
  email: "joao@teste.com",
  cpf: candidato1_cpf,
  password: "password123",
  password_confirmation: "password123"
)
candidato1 = user1.build_candidato(
  cidade: "São Paulo",
  estado: "SP",
  data_nascimento: "1995-05-10",
  escolaridade: "Ensino Médio Completo",
  trabalhando: false,
  possui_beneficio: true,
  possui_deficiencia: true
)
candidato1.save!(validate: false)
puts "Candidato 1 criado! CPF: #{candidato1_cpf} | Senha: password123"

candidato2_cpf = CPF.generate
user2 = Usuario.create!(
  nome: "Maria Souza",
  email: "maria@teste.com",
  cpf: candidato2_cpf,
  password: "password123",
  password_confirmation: "password123"
)
candidato2 = user2.build_candidato(
  cidade: "Rio de Janeiro",
  estado: "RJ",
  data_nascimento: "1998-12-20",
  escolaridade: "Ensino Superior Incompleto",
  trabalhando: true,
  possui_beneficio: false,
  possui_deficiencia: false
)
candidato2.save!(validate: false)
puts "Candidato 2 criado! CPF: #{candidato2_cpf} | Senha: password123"

puts "Seeds concluídos com sucesso!"

puts "Criando Usuário God Mode (Gestor, Instrutor e Candidato)..."
god_cpf = CPF.generate
god_user = Usuario.create!(
  nome: "Super Usuário",
  email: "super@maos.com",
  cpf: god_cpf,
  password: "password123",
  password_confirmation: "password123"
)

Gestor.create!(
  usuario: god_user,
  cargo: "Super Administrador",
  departamento: "Geral",
  nivel_acesso: 1,
  data_admissao: Date.today
)

god_user.create_instrutor!(
  formacao_academica: "Ensino Superior Completo",
  capacitacao: "Acessibilidade Universal",
  bio: "Sou um instrutor com privilégios de gestor e perfil de candidato."
)

god_candidato = god_user.build_candidato(
  cidade: "Brasília",
  estado: "DF",
  data_nascimento: "1990-01-01",
  escolaridade: "Ensino Superior Completo",
  trabalhando: true,
  possui_beneficio: false,
  possui_deficiencia: true,
  status: :validado
)
god_candidato.save!(validate: false)
puts "Super Usuário criado! Email: super@maos.com | CPF: #{god_cpf} | Senha: password123"

puts "Criando Cursos de teste..."
curso1 = Curso.create!(
  nome: "Introdução a Libras",
  area: "Línguas",
  titulo: "Aprenda o básico de Libras",
  descricao: "Um curso completo para iniciantes na Língua Brasileira de Sinais.",
  youtube_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  status: :publicado
)
curso2 = Curso.create!(
  nome: "Acessibilidade Web",
  area: "Tecnologia",
  titulo: "Construindo sites para todos",
  descricao: "Aprenda a criar interfaces digitais inclusivas.",
  youtube_url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
  status: :publicado
)
puts "Cursos criados!"
