namespace :renuo_cms_api do
  task delete_content_blocks: :environment do
    puts '========== deleting content blocks started =========='
    start_time = Time.now
    ContentBlock.delete_all
    end_time = Time.now
    puts "========== deleting content blocks finished in #{end_time - start_time}s =========="
  end
end
