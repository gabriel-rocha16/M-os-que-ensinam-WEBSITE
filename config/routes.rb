Rails.application.routes.draw do
  devise_for :usuarios

  devise_scope :usuario do
    get "login", to: "devise/sessions#new"
    get "signup", to: "devise/registrations#new"
    delete "logout", to: "devise/sessions#destroy"
  end

  resources :candidatos, only: [ :new, :create ]
  resource :candidato, only: [ :show, :edit, :update ]
  resources :instrutores, only: [ :new, :create ]

  resources :cursos do
    member do
      post :matricular
    end
  end

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :usuarios, only: [:index, :update, :destroy] do
      member do
        patch :validar_candidato
        patch :rejeitar_candidato
        patch :promover_instrutor
      end
    end
  end

  get "aluno/dashboard", to: "dashboards#aluno", as: :aluno_dashboard

  get "about", to: "pages#about"
  get "contact", to: "pages#contact"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "pages#home"

  # Rota catch-all redirecionando rotas inexistentes para a home
  match "*path", to: "application#not_found", via: :all, constraints: lambda { |req| req.path.exclude? "rails/active_storage" }
end
