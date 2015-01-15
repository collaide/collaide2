Rails.application.routes.draw do
  root to: 'main#index', as: 'root'
  localized do
    root :to => 'main#index', as: 'root'

    get 'about', to: 'main#about', as: 'about'
    get 'contact', to: 'main#contact', as: 'contact'
    get 'help', to: 'main#help', as: 'help'
    get 'partners', to: 'main#partners', as: 'partners'
    get 'rules', to: 'main#rules', as: 'rules'
    post 'contact', to: 'main#send_email', as: 'send_email_contact'
  end
end
