Rails.application.routes.draw do
  namespace :v1, defaults: { format: 'json' } do
    scope '/:api_key' do
      scope '/content_blocks', controller: :content_blocks do
        put action: :store
        get action: :index
        get '/*content_path' => 'content_blocks#fetch'
      end

      scope '/renuo_upload_credentials', controller: :renuo_upload_credentials do
        get action: :index
      end
    end
  end

  get 'home/check'
  root 'home#check'
end
