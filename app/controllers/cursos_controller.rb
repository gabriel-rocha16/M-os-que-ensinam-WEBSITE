class CursosController < ApplicationController
  skip_before_action :authenticate_usuario!, only: [:index]
  before_action :verificar_instrutor_ou_admin!, only: [:new, :create, :edit, :update, :destroy]
  before_action :autorizar_edicao_curso!, only: [:edit, :update, :destroy]

  def index
    @cursos = Curso.publicado
  end

  def show
    @curso = Curso.find(params[:id])
  end

  def new
    @curso = Curso.new
  end

  def create
    # Implementação padrão
  end

  def edit
  end

  def update
    # Implementação padrão
  end

  def destroy
    # Implementação padrão
  end

  def matricular
    @curso = Curso.find(params[:id])
    if current_usuario.candidato.present?
      current_usuario.candidato.matriculas.find_or_create_by!(curso: @curso)
      redirect_to curso_path(@curso), notice: "Matrícula realizada com sucesso!"
    else
      redirect_to cursos_path, alert: "Você precisa ser um candidato para se matricular."
    end
  end

  private

  def autorizar_edicao_curso!
    @curso = Curso.find(params[:id])
    if current_usuario.instrutor.present? && @curso.instrutor_id != current_usuario.instrutor.id
      redirect_to cursos_path, alert: "Você não tem permissão para editar este curso."
    end
  end
end
