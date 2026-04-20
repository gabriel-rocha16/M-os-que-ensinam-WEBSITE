class InstrutoresController < ApplicationController
  before_action :authenticate_usuario!

  def new
    @instrutor = current_usuario.build_instrutor
  end

  def create
    @instrutor = current_usuario.build_instrutor(instrutor_params)

    if @instrutor.save
      redirect_to root_path, notice: "Perfil de Instrutor criado com sucesso! Agora você pode gerenciar seus cursos."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def instrutor_params
    params.require(:instrutor).permit(:bio, :capacitacao, :formacao_academica)
  end
end
