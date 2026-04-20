class ApplicationController < ActionController::Base
  # Adiciona a chamada de configuração do Devise antes de qualquer ação
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_up_path_for(resource)
    new_candidato_path
  end
  # Redireciona após o login normal (caso já tenha conta)
  def after_sign_in_path_for(resource)
    if resource.gestor.present?
      dashboard_admin_path
    elsif resource.candidato.present?
      dashboard_aluno_path
    else
      root_path
    end
  end

  protected

  def configure_permitted_parameters
    # Permite nome e cpf no cadastro (sign_up)
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :nome, :cpf ])

    # Permite nome e cpf na edição de conta (account_update)
    devise_parameter_sanitizer.permit(:account_update, keys: [ :nome, :cpf ])

    # Permite que o campo híbrido :login seja usado no login (sign_in)
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :login ])
  end
end
