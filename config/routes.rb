# -*- coding: utf-8 -*-
Camk2::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  # loggin ONLY by omniauthable
  devise_scope :user do
    #get 'sign_in', :to => 'devise/sessions#new', :as => :new_user_session
    get 'sign_in', :to => 'users#welcome'
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end
  get 'settings', :to => 'users#settings'
  post 'settings', :to => 'users#update_settings'

  resources :notes
  get 'sync', to: 'notes#sync', as: :evernote_sync

  root :to => 'users#welcome'
end
