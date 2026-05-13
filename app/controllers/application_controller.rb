class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found

  before_action :authenticate_usuario!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :verificar_onboarding, unless: :devise_controller?
  helper_method :perfil_ativo, :perfis_disponiveis

  def perfis_disponiveis
    return [] unless current_usuario
    perfis = []
    perfis << 'gestor' if current_usuario.gestor.present?
    perfis << 'instrutor' if current_usuario.instrutor.present?
    perfis << 'aluno' if current_usuario.candidato.present?
    perfis
  end

  def perfil_ativo
    return nil unless current_usuario
    return session[:active_role] if session[:active_role].present? && perfis_disponiveis.include?(session[:active_role])

    novo_papel = perfis_disponiveis.first
    session[:active_role] = novo_papel
    novo_papel
  end

  def verificar_gestor_ativo!
    unless perfil_ativo == 'gestor'
      redirect_back fallback_location: root_path, alert: "Modo Gestor é necessário para acessar esta área. Alterne o seu perfil."
    end
  end

  def verificar_instrutor_ativo!
    unless perfil_ativo == 'instrutor'
      redirect_back fallback_location: root_path, alert: "Modo Instrutor é necessário para acessar esta área. Alterne o seu perfil."
    end
  end

  def verificar_admin!
    redirect_to root_path, alert: "Acesso negado. Apenas administradores." unless current_usuario&.gestor.present?
  end

  def after_sign_up_path_for(resource)
    new_candidato_path
  end
  # Redireciona após o login normal (caso já tenha conta)
  def after_sign_in_path_for(resource)
    dashboard_gateway_path
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
