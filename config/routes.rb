Rails.application.routes.draw do
  resources :admins, only: [:create, :index]
  resources :teachers, only: [:create, :destroy, :update]
  resources :klasses, only: [:create, :destroy, :update]
  resources :parents, only: [:create, :update, :destroy]
  resources :students, only: [:create, :destroy, :update]
  # resources :grade_categories
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post '/Admin_login', to: "admins#login"
  post '/Teacher_login', to: "teachers#login"
  post '/Parent_login', to: "parents#login"


  get '/me', to: "admins#me"
  get '/me', to: "teachers#me"

  patch '/grade_categories/update_class_grades', to: "grade_categories#update_class_grades"
  patch '/grade_categories/update_student_grades', to: "grade_categories#update_student_grades"
end
