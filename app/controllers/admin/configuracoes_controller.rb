class Admin::ConfiguracoesController < ApplicationController
  before_action :authenticate_usuario!
  before_action :verificar_gestor_ativo!

  def edit
    @configuracao = Configuracao.atual
  end

  def update
    @configuracao = Configuracao.atual
    if @configuracao.update(configuracao_params)
      redirect_to admin_dashboard_path, notice: "Configuração de aprovação de novos usuários salva com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def configuracao_params
    params.require(:configuracao).permit(:aprovacao_automatica)
  end
end
