Rails.application.routes.draw do
  namespace :v1, defaults: { format: 'json' } do
    scope '/:api_key' do
      scope '/content_blocks', controller: :content_blocks do
        post action: :store
        scope '/*content_path' do
          get action: :fetch
        end
      end
    end
  end

  get 'home/check'
  root 'content_blocks#index'
end
