Rails.application.routes.draw do
  get 'home/index'
  get 'home/check'

  namespace :api, defaults: {format: 'json'} do
    resources :content_blocks
  end

  resources :content_blocks
  root 'content_blocks#index'
end
