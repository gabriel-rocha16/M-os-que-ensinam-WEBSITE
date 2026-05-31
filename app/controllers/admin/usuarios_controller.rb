class Admin::UsuariosController < ApplicationController
  before_action :authenticate_usuario!
  before_action :verificar_gestor_ativo!

  def index
    @query = params[:q].to_s.strip
    @role_filter = params[:role].to_s.presence_in(%w[todos alunos instrutor gestores])

    @usuarios = Usuario.all
    @usuarios = case @role_filter
    when "instrutor"
                   @usuarios.left_outer_joins(:instrutor)
                            .where("instrutors.id IS NOT NULL")
                            .distinct
    when "gestores"
                   @usuarios.left_outer_joins(:gestor)
                            .where("usuarios.role = :gestor OR gestores.id IS NOT NULL", gestor: Usuario.roles[:gestor])
                            .distinct
    when "alunos"
                   @usuarios.left_outer_joins(:candidato)
                            .where.not(candidatos: { id: nil })
                            .distinct
    else
                   @usuarios
    end

    if @query.present?
      @usuarios = @usuarios.where("usuarios.nome ILIKE :q OR usuarios.email ILIKE :q OR usuarios.cpf ILIKE :q", q: "%#{@query}%")
    end

    @usuarios = @usuarios.order(:nome)
  end

  def pendentes
    @query = params[:q].to_s.strip

    base_scope = Candidato.pendente
                         .includes(:usuario)
                         .with_attached_curriculo
                         .with_attached_laudos_medicos

    @candidatos_pendentes = if @query.present?
      base_scope
        .joins(:usuario)
        .where("usuarios.nome ILIKE :q OR usuarios.cpf ILIKE :q", q: "%#{@query}%")
        .order("usuarios.nome")
    else
      base_scope.order(created_at: :desc)
    end
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
    if @usuario.gestor?
      redirect_to admin_usuarios_path, alert: "Não é permitido tornar um Gestor em Instrutor."
      return
    end

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
        # If the user had a candidato profile, remove it to keep roles exclusive
        @usuario.candidato.destroy if @usuario.candidato.present?
        @usuario.update!(role: :instrutor, active_role: :instrutor)
      end
      redirect_to admin_usuarios_path, notice: "Usuário #{@usuario.nome} agora é um Instrutor oficial."
    rescue ActiveRecord::RecordInvalid => e
      redirect_to admin_usuarios_path, alert: "Falha ao promover usuário: #{e.record.errors.full_messages.to_sentence}"
    rescue StandardError => e
      redirect_to admin_usuarios_path, alert: "Falha ao promover usuário: #{e.message}"
    end
  end

  def promover_gestor
    @usuario = Usuario.find(params[:id])
    if @usuario.gestor.present?
      redirect_to admin_usuarios_path, notice: "Usuário #{@usuario.nome} já é Gestor."
      return
    end

    begin
      ActiveRecord::Base.transaction do
        @usuario.create_gestor!(cargo: "Gestor", departamento: "Diretoria", nivel_acesso: 2, data_admissao: Date.today)
        @usuario.update!(role: :gestor)
      end
      redirect_to admin_usuarios_path, notice: "Usuário #{@usuario.nome} agora é Gestor."
    rescue ActiveRecord::RecordInvalid => e
      redirect_to admin_usuarios_path, alert: "Falha ao promover usuário: #{e.record.errors.full_messages.to_sentence}"
    rescue StandardError => e
      redirect_to admin_usuarios_path, alert: "Falha ao promover usuário: #{e.message}"
    end
  end

  def rebaixar_instrutor
    @usuario = Usuario.find(params[:id])
    if @usuario.instrutor.blank?
      redirect_to admin_usuarios_path, alert: "Usuário não é Instrutor."
      return
    end

    instrutor = @usuario.instrutor
    # Se o instrutor tem cursos, desassociá-los (instrutor_id -> NULL) para não violar FK
    if instrutor.cursos.exists?
      instrutor.cursos.update_all(instrutor_id: nil)
    end

    instrutor.destroy
    @usuario.update!(role: :aluno, active_role: :aluno)
    redirect_to admin_usuarios_path, notice: "Usuário #{@usuario.nome} foi rebaixado de Instrutor."
  end

  def rebaixar_gestor
    @usuario = Usuario.find(params[:id])
    if @usuario.gestor.blank?
      redirect_to admin_usuarios_path, alert: "Usuário não é Gestor."
      return
    end

    if @usuario.email.present? && @usuario.email.downcase == "admin@maos.com"
      redirect_to admin_usuarios_path, alert: "Não é permitido rebaixar o Gestor Supremo."
      return
    end

    @usuario.gestor.destroy
    @usuario.update!(role: :aluno)
    redirect_to admin_usuarios_path, notice: "Usuário #{@usuario.nome} foi rebaixado de Gestor."
  end

  def destroy
    @usuario = Usuario.find(params[:id])
    if @usuario.email.present? && @usuario.email.downcase == "admin@maos.com"
      redirect_to admin_usuarios_path, alert: "Não é permitido excluir o Gestor Supremo."
      return
    end

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
