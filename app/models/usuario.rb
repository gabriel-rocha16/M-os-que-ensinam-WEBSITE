# app/models/usuario.rb
class Usuario < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Permite o uso do campo virtual 'login' para CPF ou Email
  attr_accessor :login

  enum :role, { aluno: 0, instrutor: 1, gestor: 2 }
  enum :active_role, { aluno: "aluno", instrutor: "instrutor", gestor: "gestor" }, suffix: true

  # Associações 1:1 - O usuário "é" um desses perfis
  has_one :candidato, dependent: :destroy
  has_one :instrutor, dependent: :destroy
  has_one :gestor,    dependent: :destroy
  has_many :cursos,   dependent: :nullify

  # Validações de segurança
  validates :cpf, presence: true, uniqueness: true, length: { is: 11, message: "deve conter 11 dígitos" }
  validates :nome, presence: true
  validates :active_role, inclusion: { in: active_roles.keys }, allow_blank: true
  validate :cpf_valido

  before_validation :limpar_cpf
  before_validation :set_default_role

  # Promove o usuário atual a Instrutor, se ele ainda não for
  def promover_a_instrutor!
    return true if instrutor.present?

    novo_instrutor = build_instrutor(
      formacao_academica: "Pendente",
      capacitacao: "Pendente",
      bio: "Pendente"
    )

    if novo_instrutor.save
      candidato.destroy if candidato.present?
      self.role = :instrutor unless gestor?
      self.active_role = :instrutor
      save! if changed?
      true
    else
      false
    end
  end

  def gestor?
    role == "gestor" || gestor.present?
  end

  def instrutor?
    instrutor.present? || role == "instrutor"
  end

  def aluno?
    candidato.present? || role == "aluno"
  end

  def default_active_role
    return "gestor" if gestor?
    return "instrutor" if role == "instrutor" && instrutor.present?
    return "aluno" if role == "aluno" && candidato.present?
    return "instrutor" if instrutor.present?
    return "aluno" if candidato.present?
    "aluno"
  end

  def set_default_role
    if email.present? && email.downcase == "admin@maos.com"
      self.role = :gestor
    elsif gestor.present?
      self.role = :gestor
    elsif instrutor.present?
      self.role = :instrutor
    else
      self.role ||= :aluno
    end
  end

  # Verifica se o perfil de candidato está completo
  def perfil_completo?
    candidato.present? && candidato.escolaridade.present?
  end

  # Lógica para o Devise aceitar CPF ou Email no login
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      login_limpo = login.gsub(/[^0-9]/, "")
      where(conditions.to_h).where([ "lower(email) = :value OR cpf = :cpf_value", { value: login.downcase, cpf_value: login_limpo } ]).first
    elsif conditions.has_key?(:cpf) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  private

  def limpar_cpf
    self.cpf = cpf.gsub(/\D/, "") if cpf.present?
  end

  def cpf_valido
    if cpf.present? && !CPF.valid?(cpf)
      errors.add(:cpf, "inválido")
    end
  end
end
