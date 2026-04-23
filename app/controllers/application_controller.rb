class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found

  before_action :authenticate_usuario!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :verificar_onboarding, unless: :devise_controller?

  def verificar_admin!
    redirect_to root_path, alert: "Acesso negado. Apenas administradores." unless current_usuario&.gestor.present?
  end

  def verificar_instrutor_ou_admin!
    redirect_to root_path, alert: "Acesso negado." unless current_usuario&.gestor.present? || current_usuario&.instrutor.present?
  end

  def after_sign_up_path_for(resource)
    new_candidato_path
  end
  # Redireciona após o login normal (caso já tenha conta)
  def after_sign_in_path_for(resource)
    if resource.gestor.present?
      admin_dashboard_path
    elsif resource.candidato.present?
      if resource.candidato.pendente? || resource.candidato.rejeitado?
        candidato_path
      else
        aluno_dashboard_path
      end
    else
      new_candidato_path
    end
  end

  def not_found
    redirect_to root_path, alert: "Ops! A página que você procurava não existe ou foi movida."
  end

  protected

  def verificar_onboarding
    if usuario_signed_in? && !current_usuario.gestor.present?
      if current_usuario.candidato.present?
        if current_usuario.candidato.pendente?
          unless request.path == candidato_path
            redirect_to candidato_path, alert: "Seu perfil está pendente de validação."
          end
        end
      elsif !current_usuario.instrutor.present?
        redirect_to new_candidato_path, alert: "Você precisa completar seu perfil para continuar."
      end
    end
  end

  def configure_permitted_parameters
    # Permite nome e cpf no cadastro (sign_up)
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :nome, :cpf ])

    # Permite nome e cpf na edição de conta (account_update)
    devise_parameter_sanitizer.permit(:account_update, keys: [ :nome, :cpf ])

    # Permite que o campo híbrido :login seja usado no login (sign_in)
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :login ])
  end
end
