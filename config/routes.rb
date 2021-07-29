Rails.application.routes.draw do
  resources :admins, only: [:create, :index]
  resources :teachers, only: [:create, :destroy, :update]
  resources :klasses, only: [:create, :destroy, :update]
  # resources :parents
  resources :students, only: [:create, :destroy, :update]
  # resources :grade_categories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/admin_login', to: "admins#login"
  post '/teacher_login', to: "teachers#login"

  get '/me', to: "admins#me"
end
