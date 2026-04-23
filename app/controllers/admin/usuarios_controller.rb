class Admin::UsuariosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :verificar_gestor!

  def index
    @candidatos_pendentes = Candidato.pendente.includes(:usuario).order(created_at: :desc)
  end

  def validar_candidato
    @usuario = Usuario.find(params[:id])
    if @usuario.candidato.present?
      @usuario.candidato.validado!
      redirect_to admin_usuarios_path, notice: "Candidato #{@usuario.nome} validado com sucesso!"
    else
      redirect_to admin_usuarios_path, alert: "Usuário não possui perfil de candidato."
    end
  end

  def rejeitar_candidato
    @usuario = Usuario.find(params[:id])
    if @usuario.candidato.present?
      @usuario.candidato.rejeitado!
      redirect_to admin_usuarios_path, alert: "Candidato #{@usuario.nome} rejeitado."
    end
  end

  def promover_instrutor
    @usuario = Usuario.find(params[:id])
    if @usuario.promover_a_instrutor!
      redirect_to admin_usuarios_path, notice: "Usuário #{@usuario.nome} agora é um Instrutor oficial."
    else
      redirect_to admin_usuarios_path, alert: "Falha ao promover usuário."
    end
  end

  private

  def verificar_gestor!
    unless current_usuario.gestor.present?
      redirect_to root_path, alert: "Acesso negado. Apenas gestores podem realizar esta ação."
    end
  end
end
