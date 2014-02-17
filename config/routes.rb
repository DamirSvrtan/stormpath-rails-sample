StormpathSample::Application.routes.draw do

  root to: 'users#index'

  resource :session, only: [:new, :create, :destroy]

  get 'password-reset/:sptoken' => 'password_reset_tokens#edit', as: :password_reset
  put 'password-reset/:sptoken' => 'password_reset_tokens#update', as: :update_password
  get 'password-reset' => 'password_reset_tokens#new', as: :new_password_reset
  post 'password-reset' => 'password_reset_tokens#create', as: :request_password_token

  resources :users do
    get 'verify', on: :collection
    resource :group_memberships
  end

  get '/admin' => "admin#index"
  resource :directories
  resource :groups
  resource :account_store, only: [:create]
  resource :account_store_mappings

end
