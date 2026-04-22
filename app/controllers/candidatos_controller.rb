class CandidatosController < ApplicationController
  before_action :authenticate_usuario!
  skip_before_action :verificar_onboarding, only: [:new, :create]

  def show
    @candidato = current_usuario.candidato
    redirect_to new_candidato_path unless @candidato.present?
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
      laudos_medicos: []
    )
  end
end
