Rails.application.routes.draw do
  resources :customers do 
    get 'customer_csv_export', on: :member
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
