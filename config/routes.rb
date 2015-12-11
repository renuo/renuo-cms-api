Rails.application.routes.draw do
  namespace :v1, defaults: { format: 'json' } do
    scope '/:api_key' do
      scope '/content_blocks', controller: :content_blocks do
        post action: :store
        get action: :index
        get '/*content_path' => 'content_blocks#fetch'
      end
    end
  end

  get 'home/check'
  root 'home#check'
end
