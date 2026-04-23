class CandidatosController < ApplicationController
  before_action :authenticate_usuario!
  skip_before_action :verificar_onboarding, only: [:new, :create, :edit, :update]

  def show
    @candidato = current_usuario.candidato
    redirect_to new_candidato_path unless @candidato.present?
  end

  def edit
    @candidato = current_usuario.candidato
    redirect_to new_candidato_path unless @candidato.present?
  end

  def update
    @candidato = current_usuario.candidato
    
    # Previne que o ActiveStorage delete os laudos atuais se o campo vier vazio
    if params[:candidato][:laudos_medicos].blank? || params[:candidato][:laudos_medicos].all?(&:blank?)
      params[:candidato].delete(:laudos_medicos)
    end

    if @candidato.update(candidato_params)
      # Se os dados mudaram, é prudente voltar o status para pendente para reanálise, exceto se for Gestor. 
      # Mas como o requisito não exige, apenas salvamos.
      redirect_to candidato_path, notice: "Perfil atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def new
    @candidato = current_usuario.build_candidato
  end

  def create
    @candidato = current_usuario.build_candidato(candidato_params)

    if @candidato.save
      redirect_to root_path, notice: "Perfil de Candidato criado com sucesso!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def candidato_params
    params.require(:candidato).permit(
      :cidade, :estado, :data_nascimento, :escolaridade,
      :trabalhando, :possui_beneficio, :possui_deficiencia, 
      :tipo_deficiencia, :beneficio_tipo, :curriculo_url,
      :telefone, :curriculo,
      laudos_medicos: []
    )
  end
end
