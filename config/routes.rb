Rails.application.routes.draw do
  get 'home/index'
  get 'home/check'

  resources :content_blocks
end
