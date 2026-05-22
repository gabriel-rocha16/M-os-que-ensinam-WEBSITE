class Admin::UsuariosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :verificar_gestor_ativo!

  def index
    @candidatos_pendentes = Candidato.pendente.includes(:usuario).order(created_at: :desc)
  end

  def validar_candidato
    @usuario = Usuario.find(params[:id])
    if @usuario.candidato.present?
      begin
        ActiveRecord::Base.transaction do
          @usuario.candidato.validado!
        end
        redirect_to admin_usuarios_path, notice: "Candidato #{@usuario.nome} validado com sucesso!"
      rescue ActiveRecord::RecordInvalid => e
        redirect_to admin_usuarios_path, alert: "Falha ao validar candidato: #{e.record.errors.full_messages.to_sentence}"
      rescue StandardError => e
        redirect_to admin_usuarios_path, alert: "Falha ao validar candidato: #{e.message}"
      end
    else
      redirect_to admin_usuarios_path, alert: "Usuário não possui perfil de candidato."
    end
  end

  def rejeitar_candidato
    @usuario = Usuario.find(params[:id])
    if @usuario.candidato.present?
      begin
        ActiveRecord::Base.transaction do
          @usuario.candidato.rejeitado!
        end
        redirect_to admin_usuarios_path, alert: "Candidato #{@usuario.nome} rejeitado."
      rescue ActiveRecord::RecordInvalid => e
        redirect_to admin_usuarios_path, alert: "Falha ao rejeitar candidato: #{e.record.errors.full_messages.to_sentence}"
      rescue StandardError => e
        redirect_to admin_usuarios_path, alert: "Falha ao rejeitar candidato: #{e.message}"
      end
    else
      redirect_to admin_usuarios_path, alert: "Usuário não possui perfil de candidato."
    end
  end

  def promover_instrutor
    @usuario = Usuario.find(params[:id])
    if @usuario.instrutor.present?
      redirect_to admin_usuarios_path, notice: "Usuário #{@usuario.nome} já é um Instrutor oficial."
      return
    end

    begin
      ActiveRecord::Base.transaction do
        instrutor = @usuario.build_instrutor(
          formacao_academica: "Pendente",
          capacitacao: "Pendente",
          bio: "Pendente"
        )
        instrutor.save!
      end
      redirect_to admin_usuarios_path, notice: "Usuário #{@usuario.nome} agora é um Instrutor oficial."
    rescue ActiveRecord::RecordInvalid => e
      redirect_to admin_usuarios_path, alert: "Falha ao promover usuário: #{e.record.errors.full_messages.to_sentence}"
    rescue StandardError => e
      redirect_to admin_usuarios_path, alert: "Falha ao promover usuário: #{e.message}"
    end
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    @usuario.destroy
    redirect_to admin_usuarios_path, notice: "Usuário excluído fisicamente com sucesso."
  end

  def remover_candidatura
    @usuario = Usuario.find(params[:id])
    if @usuario.candidato.present?
      @usuario.candidato.destroy
      redirect_to admin_usuarios_path, notice: "Perfil PcD removido. O usuário agora é apenas um visitante."
    else
      redirect_to admin_usuarios_path, alert: "Este usuário não tem candidatura."
    end
  end
end
