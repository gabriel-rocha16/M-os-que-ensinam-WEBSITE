class CandidatosController < ApplicationController
  before_action :authenticate_usuario!

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
      :trabalhando, :possui_beneficio, :possui_deficiencia, :curriculo_url
    )
  end
end
