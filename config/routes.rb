Jantire::Application.routes.draw do
  resources :courses

  devise_for :users
  root :to => "assignments#index"
  match '/assignments/:id/turn_in' => 'assignments#turn_in'
  match '/assignments/:id/grade' => 'assignments#grade' 
  match '/assignments/:id/egp' => 'assignments#egp'
  match '/courses/:id/leave' => 'courses#leave'
  match '/courses/:id/join' => "courses#join"
  match '/user/:id/grades' => "grades#index" 
  get '/assignments/:id/destroy' => 'assignments#destroy'
  resources :assignments do
    resources :grades
  end
  resources :grades
end
