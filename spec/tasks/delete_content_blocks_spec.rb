require 'rails_helper.rb'
require 'rake'

RSpec.describe 'renuo_cms_api:delete_content_blocks' do
  it 'should delete all content_blocks from the database' do
    create_list(:content_block, 2)
    RenuoCmsApi::Application.load_tasks
    Rake::Task.define_task(:environment)
    expect { Rake::Task['renuo_cms_api:delete_content_blocks'].invoke }.to change { ContentBlock.count }.from(2).to(0)
  end
end
