Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  match '/users/validate_sign_up' => 'users#validate_sign_up', via: [:get, :post], :as => :validate_sign_up

  root 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :vote_cancel
    end
  end

  resources :questions, concerns: :votable, shallow: true do
    resources :comments, defaults: { commentable: 'questions' }

    resources :answers, except: [:index, :show], shallow: true, concerns: :votable do
      resources :comments, defaults: { commentable: 'answers' }
      post 'best', on: :member
    end
  end

  resources :attachments, only: [:destroy]

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
    end
  end
end
