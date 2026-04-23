class PagesController < ApplicationController
  skip_before_action :authenticate_usuario!, only: [:home, :about, :contact]
  skip_before_action :verificar_onboarding, only: [:home, :about, :contact]

  def home
    render "pages/landingPage/home"
  end

  def about
  end

  def contact
  end
end
