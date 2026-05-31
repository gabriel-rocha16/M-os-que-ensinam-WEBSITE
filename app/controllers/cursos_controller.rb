class CursosController < ApplicationController
  skip_before_action :authenticate_usuario!, only: [ :index, :show ]
  before_action :verificar_instrutor_ativo!, only: [ :new, :create, :edit, :update, :destroy, :solicitar_aprovacao ]
  before_action :set_curso, only: [ :show, :edit, :update, :destroy, :solicitar_aprovacao ]
  before_action :authorize_own_course!, only: [ :edit, :update, :destroy, :solicitar_aprovacao ]

  def index
    @cursos = Curso.publicado.includes(:matriculas).order(nome: :asc)
  end

  def show
    unless @curso.publicado? || (current_usuario && (@curso.usuario_id == current_usuario.id || current_usuario.gestor?))
      redirect_to cursos_path, alert: "Este curso ainda não está disponível publicamente."
    end
  end

  def new
    @curso = Curso.new
  end

  def create
    @curso = Curso.new(curso_params)
    @curso.usuario = current_usuario
    @curso.instrutor = current_usuario.instrutor

    if @curso.save
      redirect_to dashboard_path_for(current_usuario), notice: "Curso criado com sucesso e está como Rascunho."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @curso.update(curso_params)
      redirect_to dashboard_path_for(current_usuario), notice: "Curso atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @curso.matriculas.exists?
      redirect_to dashboard_path_for(current_usuario), alert: "Este curso possui alunos e não pode ser excluído. Arquive-o em vez disso."
    else
      @curso.destroy
      redirect_to dashboard_path_for(current_usuario), notice: "Curso excluído."
    end
  end

  def solicitar_aprovacao
    @curso.aguardando_aprovacao!
    redirect_to dashboard_path_for(current_usuario), notice: "Curso enviado para revisão."
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

  def authorize_own_course!
    unless @curso.usuario_id == current_usuario.id
      redirect_to dashboard_path_for(current_usuario), alert: "Acesso não autorizado."
    end
  end

  def set_curso
    @curso = Curso.find(params[:id])
  end

  def curso_params
    params.require(:curso).permit(:nome, :area, :descricao, :carga_horaria, :youtube_url, :moodle_url)
  end
end
