# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post 'signup', action: :signup, controller: :signup
        post '/login', action: :login, controller: :login
        delete '/logout', action: :logout, controller: :login
      end

      ## User Api-------------------------------------------------------
      scope 'users' do
        get 'friends', action: :friend_list, controller: :users
        get 'friends-name', action: :friend_names, controller: :users

        get 'search-profile', action: :search_profile, controller: :users
        patch 'email-verify/:token', action: :email_verification,
                                     controller: :users
      end
      resources :users, only: %i[index update show]

      ## Friend Api------------------------------------------------------
      scope 'friends' do
        patch 'request-verify/:token', action: :email_request_accept,
                                       controller: :friends
        patch 'subscribe/:id', action: :subscribe, controller: :friends
      end
      resource :friends, only: %i[create update], path: 'friends/request/:id'

      ## Post Api---------------------------------------------------------
      scope 'posts' do
        get 'friends', action: :friend_posts, controller: :posts
        get 'users/:id', action: :user_posts, controller: :posts
      end
      resources :posts, only: %i[index create show update]
    end
  end
end
