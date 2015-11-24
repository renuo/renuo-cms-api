Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    scope '/content_blocks', controller: :content_blocks do
      scope '/:api_key' do
        scope '/*content_path' do
          get action: :show
          post action: :update
        end
      end
    end
  end

  get 'home/check'
  root 'content_blocks#index'
end
