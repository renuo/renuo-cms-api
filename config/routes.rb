Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    scope '/content_blocks', controller: :content_blocks do
      scope '/:api_key' do
        post action: :create
        scope '/*content_path' do
          get action: :show
          patch action: :update
          delete action: :destroy
        end
      end
    end
  end

  get 'home/check'
  root 'content_blocks#index'
end
