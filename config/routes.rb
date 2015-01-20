Rails.application.routes.draw do
  root to: 'main#index', as: 'root'
  devise_for :users, :controllers => {omniauth_callbacks: 'users/omniauth_callbacks', registrations: 'users/registrations', sessions: 'users/sessions' }
  localized do
    #MainController
    root :to => 'main#index', as: 'root'
    get 'about', to: 'main#about', as: 'about'
    get 'contact', to: 'main#contact', as: 'contact'
    get 'help', to: 'main#help', as: 'help'
    get 'partners', to: 'main#partners', as: 'partners'
    get 'rules', to: 'main#rules', as: 'rules'
    post 'contact', to: 'main#send_email', as: 'send_email_contact'

    #UsersController
    resources :users, only: [:show] do
      get 'groups'
    end

    resources :groups, as: 'group_groups', controller: 'group/groups', only: [:create, :new, :show]
  end

  namespace :api do
    resources :auth_token, controller: 'auth_token', only: [:create]
    resources :users, controller: 'users', only: :show do
      post 'valid', on: :collection
    end
  end
end
