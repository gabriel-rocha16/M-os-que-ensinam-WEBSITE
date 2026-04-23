# app/models/usuario.rb
class Usuario < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Permite o uso do campo virtual 'login' para CPF ou Email
  attr_accessor :login

  # Associações 1:1 - O usuário "é" um desses perfis
  has_one :candidato, dependent: :destroy
  has_one :instrutor, dependent: :destroy
  has_one :gestor,    dependent: :destroy
  has_many :cursos,   dependent: :nullify

  # Validações de segurança
  validates :cpf, presence: true, uniqueness: true, length: { is: 11, message: "deve conter 11 dígitos" }
  validates :nome, presence: true
  validate :cpf_valido

  before_validation :limpar_cpf

  # Promove o usuário atual a Instrutor, se ele ainda não for
  def promover_a_instrutor!
    return true if instrutor.present?

    novo_instrutor = build_instrutor(
      formacao_academica: "Pendente",
      capacitacao: "Pendente",
      bio: "Pendente"
    )
    novo_instrutor.save
  end

  # Verifica se o perfil de candidato está completo
  def perfil_completo?
    candidato.present? && candidato.escolaridade.present?
  end

  # Lógica para o Devise aceitar CPF ou Email no login
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where([ "cpf = :value OR lower(email) = lower(:value)", { value: login } ]).first
    elsif conditions.has_key?(:cpf) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  private

  def limpar_cpf
    self.cpf = cpf.gsub(/\D/, '') if cpf.present?
  end

  def cpf_valido
    if cpf.present? && !CPF.valid?(cpf)
      errors.add(:cpf, "inválido")
    end
  end
end
