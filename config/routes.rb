Rails.application.routes.draw do
  mount Avo::Engine, at: Avo.configuration.root_path
  resources :videos
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "dashboards#index"

  get :sign_up, to: "users#sign_up"
  post :create, to: "users#create"
  get :sign_in, to: "users#sign_in"
  post :log_in, to: "users#log_in"
  get :sign_out, to: "users#sign_out"

  namespace :students do
    get :portal, to: "students#index"

    # quizzes
    get :quizzes, to: "students#quizzes"
    get "quizzes/:id", to: "students#show_quiz", as: :show_quiz
    get "quizzes/:id/attempt", to: "students#attempt_quiz", as: :attempt_quiz
    get "quizzes/:id/attempt/:question_id", to: "students#attemptting_quiz", as: :attemptting_quiz
    post "quizzes/:id/attempt", to: "students#submit_quiz", as: :submit_quiz
    get "submitted", to: "students#submitted"
    get "submitted/:id", to: "students#show_submitted", as: :show_submitted
    get :submitted_quizzes, to: "students#submitted_quizzes"

    # reports
    get :reports, to: "students#reports"
    get "reports/:id", to: "students#show_report", as: :show_report
    get "reports/:id/download", to: "students#download_report", as: :download_report

    # videos
    get :videos, to: "students#videos"
    get "videos/:id", to: "students#show_video", as: :show_video
    get "videos/:id/download", to: "students#download_video", as: :download_video
    get "answer", to: "students#answer"
  end

  namespace :teachers do
    get :portal, to: "teachers#index"

    # students
    get :students, to: "teachers#students"
    get :new_student, to: "teachers#new_student"
    post :add_student, to: "teachers#add_student"
    get "students/:id", to: "teachers#show_student", as: :show_student
    get "students/:id/edit", to: "teachers#edit_student", as: :edit_student
    patch "students/:id", to: "teachers#update_student", as: :update_student
    delete "students/:id", to: "teachers#destroy_student", as: :destroy_student

    # quizzes
    resources :quizzes do
      get :submitted, on: :collection
      get :show_submitted
    end
    post "mark_question/:id", to: "quizzes#mark_question", as: :mark_question
    resources :reports
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
