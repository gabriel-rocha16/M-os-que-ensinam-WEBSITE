class DashboardsController < ApplicationController
  before_action :authenticate_usuario!

  def admin
  end

  def aluno
  end
end
