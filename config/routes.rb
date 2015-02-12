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
      get 'notifications'
    end

    # GroupsController
    resources :groups, as: 'group_groups', controller: 'group/groups', only: [:create, :new, :show] do
      get 'create/user-infos', controller: 'group/groups_creator', action: 'user_login', as: 'create_user_login' # Pour la création d'un groupe pas à pas
      post 'create/user-infos', controller: 'group/groups_creator', action: 'save_user_login', as: 'create_user_login' # Pour la création d'un groupe pas à pas
      get 'create/password', controller: 'group/groups_creator', action: 'password', as: 'create_password' # Pour la création d'un groupe pas à pas
      get 'create/invitations', controller: 'group/groups_creator', action: 'invitations', as: 'create_invitations' # Pour la création d'un groupe pas à pas
      # TopicsController -> discussions
      resources :invitations, controller: 'group/invitations', only: [:index, :create, :destroy]
      resources :topics, controller: 'group/topics' do
        resources :comments, controller: 'group/comments', only: [:create, :update, :edit, :destroy]
      end
      resources :email_invitations, controller: 'group/email_invitations', only: [:destroy] do
        collection do
          patch ':id/secret_token/:secret_token', action: :update, as: ''
          get ':id/secret_token/:secret_token', action: :update, as: ''
        end
      end
    end
  end

  namespace :api do
    resources :auth_token, controller: 'auth_token', only: [:create]
    resources :comment_views, controller: 'comment_views', only: [:create, :index]
    resources :users, controller: 'users', only: :show do
      post 'valid', on: :collection
    end
    resources :search, only: :index do
      collection do
        get :users
      end
    end
  end
end
