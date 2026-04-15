class Usuario < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         authentication_keys: [ :login ]

  attr_accessor :login

  # Lógica para permitir login com CPF ou Email
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where([ "cpf = :value OR lower(email) = :value", { value: login.downcase } ]).first
    elsif conditions.has_key?(:cpf) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end
end
