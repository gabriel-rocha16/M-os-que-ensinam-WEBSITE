Rails.application.routes.draw do
  devise_for :usuarios
  
  resources :candidatos, only: [:new, :create]
  resources :instrutores, only: [:new, :create]

  get 'dashboard_admin', to: 'dashboards#admin'
  get 'dashboard_aluno', to: 'dashboards#aluno'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "rails/health#show"
end
