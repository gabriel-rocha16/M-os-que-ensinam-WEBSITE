class Admin::InstrutoresController < ApplicationController
  before_action :authenticate_usuario!
  before_action :verificar_gestor_ativo!

  def index
    @instrutores = Instrutor.includes(:usuario, :cursos).order("usuarios.nome").references(:usuario)
  end
end
