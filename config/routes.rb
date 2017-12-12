Rails.application.routes.draw do
  resources :games do
  	resources :frames
  end
  
  resources :users

  root 'games#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
