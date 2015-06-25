Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    # TODO: file this evil hack as a rails bug:
    #resources :content_blocks, except: [:index, :new, :edit], param: 'api_key/:content_path'

    scope '/content_blocks', controller: :content_blocks do
      scope '/:api_key' do
        post action: :create
        scope '/:id' do
          get action: :show
          put action: :update
          delete action: :destroy
        end
      end
    end
  end

  get 'home/check'
  root 'content_blocks#index'
end
