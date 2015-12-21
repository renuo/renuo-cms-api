namespace :renuo_cms_api do
  task delete_content_blocks: :environment do
    ContentBlock.delete_all
  end
end
