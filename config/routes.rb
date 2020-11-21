Rails.application.routes.draw do
	devise_for :user
	root "homes#index"
	resources :reports
	resources :patients do
		collection do
			post "report_generator"
			post "export_options"
		end
		member do
			get "report"
		end
	end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
