module AdminAuthorization
  extend ActiveSupport::Concern

  included do
    helper_method :admin_user?
  end

  def admin_user?
    current_usuario&.gestor?
  end

  def authorize_admin!
    redirect_to root_path, alert: "Acesso não autorizado." unless admin_user?
  end
end
