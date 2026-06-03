class ApplicationController < ActionController::Base
  include AdminAuthorization

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActionController::RoutingError, with: :not_found
  rescue_from ActiveRecord::RecordNotUnique, with: :handle_duplicate_record

  before_action :authenticate_usuario!
  before_action :set_default_role
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :verificar_onboarding, unless: :devise_controller?
  helper_method :perfil_ativo, :perfis_disponiveis, :dashboard_path_for

  def set_default_role
    return unless usuario_signed_in?

    if current_usuario.active_role.present? && perfis_disponiveis.include?(current_usuario.active_role)
      session[:active_role] = current_usuario.active_role
      return
    end

    novo_role = current_usuario.default_active_role
    current_usuario.update!(active_role: novo_role) if current_usuario.active_role != novo_role
    session[:active_role] = novo_role
  end

  def perfis_disponiveis
    return [] unless current_usuario
    perfis = []
    perfis << "gestor" if current_usuario.gestor?
    perfis << "instrutor" if current_usuario.instrutor?
    perfis << "aluno" if current_usuario.candidato.present?
    perfis.uniq
  end

  def perfil_ativo
    return nil unless current_usuario
    current_usuario.active_role.presence || session[:active_role] || current_usuario.default_active_role
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
    authorize_admin!
  end

  def dashboard_path_for(usuario = current_usuario)
    role = usuario&.active_role.presence || usuario&.default_active_role
    case role
    when "gestor"
      admin_dashboard_path
    when "instrutor"
      instrutor_dashboard_path
    when "aluno"
      aluno_dashboard_path
    else
      root_path
    end
  end

  def after_sign_up_path_for(resource)
    dashboard_gateway_path
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
    return if !usuario_signed_in? || current_usuario.gestor?

    if current_usuario.candidato.present?
      if current_usuario.candidato.pendente?
        unless request.path == candidato_path
          redirect_to candidato_path, alert: "Seu perfil está pendente de validação."
        end
      end
    elsif !current_usuario.instrutor?
      redirect_to new_candidato_path, alert: "Você precisa completar seu perfil para continuar."
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
