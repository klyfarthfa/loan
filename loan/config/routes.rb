Rails.application.routes.draw do
  resources :loan_applications, :only => [:new, :show, :create]
  root "loan_applications#new"
end
