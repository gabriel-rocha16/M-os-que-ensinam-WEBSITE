class CursosController < ApplicationController
  skip_before_action :authenticate_usuario!, only: [:index]
  before_action :verificar_instrutor_ativo!, only: [:new, :create, :edit, :update, :destroy]
  before_action :autorizar_edicao_curso!, only: [:edit, :update, :destroy]

  def index
    @cursos = Curso.publicado
  end

  def show
    @curso = Curso.find(params[:id])
    
    unless @curso.publicado? || (current_usuario && (@curso.usuario_id == current_usuario.id || current_usuario.gestor.present?))
      redirect_to cursos_path, alert: "Este curso ainda não está disponível publicamente."
    end
  end

  def new
    @curso = Curso.new
  end

  def create
    @curso = Curso.new(curso_params)
    @curso.usuario_id = current_usuario.id
    
    if @curso.save
      redirect_to admin_dashboard_path, notice: "Curso criado com sucesso e está como Rascunho."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @curso = Curso.find(params[:id])
  end

  def update
    @curso = Curso.find(params[:id])
    if @curso.update(curso_params)
      redirect_to admin_dashboard_path, notice: "Curso atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @curso = Curso.find(params[:id])
    @curso.destroy
    redirect_to admin_dashboard_path, notice: "Curso excluído."
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
    unless current_usuario.gestor.present? || @curso.usuario_id == current_usuario.id
      redirect_to admin_dashboard_path, alert: "Você não tem permissão para editar este curso."
    end
  end

  def curso_params
    params.require(:curso).permit(:nome, :area, :descricao, :carga_horaria, :youtube_url, :moodle_url)
  end
end
