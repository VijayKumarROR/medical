Rails.application.routes.draw do
	devise_for :user
	root "homes#index"
	resources :reports
	resources :patients
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
