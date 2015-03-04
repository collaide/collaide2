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
      get 'invitations'
    end

    # GroupsController
    resources :groups, as: 'group_groups', controller: 'group/groups', only: [:create, :new, :show] do
      get 'create/user-infos', controller: 'group/groups_creator', action: 'user_login', as: 'create_user_login' # Pour la création d'un groupe pas à pas
      post 'create/user-infos', controller: 'group/groups_creator', action: 'save_user_login', as: 'create_user_login' # Pour la création d'un groupe pas à pas
      get 'create/password', controller: 'group/groups_creator', action: 'password', as: 'create_password' # Pour la création d'un groupe pas à pas
      get 'create/invitations', controller: 'group/groups_creator', action: 'invitations', as: 'create_invitations' # Pour la création d'un groupe pas à pas
      # TopicsController -> discussions
      resources :invitations, controller: 'group/invitations', only: [:index, :create, :destroy, :update] do
        get ':id', action: :update, on: :collection
      end
      resources :topics, controller: 'group/topics' do
        resources :comments, controller: 'group/comments', only: [:create, :update, :edit, :destroy]
      end
      resources :email_invitations, controller: 'group/email_invitations', only: [:destroy] do
        collection do
          match ':id/secret_token/:secret_token', action: :update, as: '', via: [:get, :patch]
          get ':id/secret_token/:secret_token/confirm', action: :confirm, as: 'confirm'
          get ':id/secret_token/:secret_token/send_confirmation', action: :send_confirmation, as: 'send_confirmation'
          get ':id/secret_token/:secret_token/reset_session', action: :clear_session, as: 'reset_session'
        end
      end
      resources :repo_items, only: [:index, :show, :destroy] do
        get 'download'
        get 'search'
        patch 'copy', action: :copy
        patch 'move', action: :move
        patch 'rename', action: :rename
        collection do
          post 'folder', action: :create_folder, :as => 'create_folder'
          post 'file', action: :create_file, :as => 'create_file'
          post 'files', action: :create_files
        end
        resources :sharings, only: [:new, :create, :destroy] do

        end
      end
      resources :admin, controller: 'group/admin', only: :index
      resources :members, controller: 'group/members', only: [:index, :update]
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
