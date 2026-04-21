Rails.application.routes.draw do
  get "pages/home"
  devise_for :usuarios

  get "/login", to: "devise/sessions#new", as: :login
  get "/signup", to: "devise/registrations#new", as: :signup

  resources :candidatos, only: [ :new, :create ]
  resources :instrutores, only: [ :new, :create ]

  get "dashboard_admin", to: "dashboards#admin"
  get "dashboard_aluno", to: "dashboards#aluno"

  get "about", to: "pages#about"
  get "cursos", to: "pages#cursos"
  get "contact", to: "pages#contact"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"
end
