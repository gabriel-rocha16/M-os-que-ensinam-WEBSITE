class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :handle_duplicate_record

  before_action :authenticate_usuario!
  before_action :set_default_role
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :verificar_onboarding, unless: :devise_controller?
  helper_method :perfil_ativo, :perfis_disponiveis

  def set_default_role
    if usuario_signed_in? && session[:active_role].blank?
      if current_usuario.gestor.present?
        session[:active_role] = "gestor"
      elsif current_usuario.instrutor.present?
        session[:active_role] = "instrutor"
      elsif current_usuario.candidato.present?
        session[:active_role] = "aluno"
      end
    end
  end

  def perfis_disponiveis
    return [] unless current_usuario
    perfis = []
    perfis << "gestor" if current_usuario.gestor.present?
    perfis << "instrutor" if current_usuario.instrutor.present?
    perfis << "aluno" if current_usuario.candidato.present?
    perfis
  end

  def perfil_ativo
    return nil unless current_usuario
    session[:active_role]
  end

  def verificar_gestor_ativo!
    unless perfil_ativo == "gestor"
      redirect_back fallback_location: root_path, alert: "Modo Gestor é necessário para acessar esta área. Alterne o seu perfil."
    end
  end

  def verificar_instrutor_ativo!
    unless perfil_ativo == "instrutor"
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

  private

  def handle_duplicate_record(exception)
    flash[:alert] = "CPF ou E-mail já está cadastrado. Verifique seus dados e tente novamente."
    redirect_back fallback_location: root_path
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
    # Permite nome, cpf e email no cadastro (sign_up)
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :nome, :cpf, :email, :password, :password_confirmation ])

    # Permite nome, cpf e email na edição de conta (account_update)
    devise_parameter_sanitizer.permit(:account_update, keys: [ :nome, :cpf, :email ])

    # Permite que o campo híbrido :login seja usado no login (sign_in)
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :login ])
  end
end
