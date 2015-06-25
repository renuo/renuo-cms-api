Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    resources :content_blocks, except: [:index]
  end

  get 'home/check'
  root 'content_blocks#index'
end
