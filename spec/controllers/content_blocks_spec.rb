require 'rails_helper'

RSpec.describe V1::ContentBlocksController, type: :controller do
  let!(:content_block) { create(:content_block) }

  context 'requesting a content block' do
    def expect_content_blocks_to_be_equal(expected_content_block, raw_content_block)
      content_block = OpenStruct.new(raw_content_block)
      expect(content_block.content).to eq(expected_content_block.content)
      expect(content_block.content_path).to eq(expected_content_block.content_path)
      expect(content_block.api_key).to eq(expected_content_block.api_key)
      expect(content_block.id).to be_nil
    end

    describe 'GET index' do
      before(:each) { Rails.cache.clear }

      it 'returns the right JSON content' do
        content_block2 = create(:content_block, api_key: content_block.api_key)
        create(:content_block, api_key: 'some-other-key')
        get :index, api_key: content_block.api_key
        content_blocks = JSON.parse(assigns(:content_blocks_json))['content_blocks']
        expect(content_blocks.size).to eq(2)
        expect_content_blocks_to_be_equal(content_block, content_blocks[0])
        expect_content_blocks_to_be_equal(content_block2, content_blocks[1])
        expect(response).to have_http_status(:ok)

        blocks = JSON.parse(response.body)['content_blocks']
        expect(blocks.size).to eq(2)
        expect_content_blocks_to_be_equal(content_block, blocks[0])
        expect_content_blocks_to_be_equal(content_block2, blocks[1])
      end

      it 'uses the http cache with etag' do
        def expect_status_code_accessed_with_etag(etag, http_status_code)
          request.env['HTTP_IF_NONE_MATCH'] = etag if etag
          get :index, api_key: content_block.api_key
          expect(response).to have_http_status http_status_code
          etag = response.headers['ETag']
          expect(etag).to be_truthy
          etag
        end

        etag = expect_status_code_accessed_with_etag(nil, 200)
        etag = expect_status_code_accessed_with_etag(etag, 304)

        Timecop.travel 1.day.since
        create(:content_block, api_key: 'anotherAPIKey')
        etag = expect_status_code_accessed_with_etag(etag, 304)

        Timecop.travel 1.day.since
        create(:content_block, api_key: content_block.api_key)
        etag = expect_status_code_accessed_with_etag(etag, 200)
        etag = expect_status_code_accessed_with_etag(etag, 304)

        Timecop.travel 1.day.since
        content_block.update(content: 'foooo')
        etag = expect_status_code_accessed_with_etag(etag, 200)
        expect_status_code_accessed_with_etag(etag, 304)
      end
    end

    describe 'GET fetch' do
      it 'checks whether the right JSON responds to a GET request to a show action' do
        get :fetch, api_key: content_block.api_key, content_path: content_block.content_path
        expect(assigns(:content_block)).to eq(content_block)
        expect(assigns(:content_block).created_at).to be_within(5.seconds).of(content_block.created_at)
        expect(response).to have_http_status(:ok)
        object = JSON.parse(response.body)['content_block']
        expect_content_blocks_to_be_equal(content_block, object)
      end

      it 'renders return an empty content without corresponding resource' do
        get :fetch, api_key: 'non-existing-api-key', content_path: 'non-existing-content-path'
        content_block = assigns(:content_block)
        expect(content_block.created_at).to be_nil
        expect(content_block.content).to eq('')
        expect(content_block.api_key).to eq('non-existing-api-key')
        expect(content_block.content_path).to eq('non-existing-content-path')
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'changing a content block' do
    let!(:credential_pair) { create(:credential_pair, api_key: content_block.api_key) }
    let(:authorized_api_params) { { api_key: content_block.api_key, private_api_key: credential_pair.private_api_key } }
    let(:content_block_params) do
      { content_block: { content_path: content_block.content_path, api_key: content_block.api_key,
                         content: content_block.content } }
    end
    let(:merged_params) { authorized_api_params.merge content_block_params }

    describe 'PUT store' do
      it 'creates a new block content' do
        expect do
          new_params = { content_block: { content: 'new content!', content_path: 'some-content-path' } }
          put :store, authorized_api_params.merge(new_params)
        end.to change { ContentBlock.count }.by(1)

        expect(ContentBlock.last.content).to eq('new content!')
        expect(ContentBlock.last.content_path).to eq('some-content-path')
        expect(response).to have_http_status(:ok)
      end

      it 'stores the content of an existing content block' do
        new_content_block = {
          content_path: content_block.content_path,
          api_key: content_block.api_key,
          content: 'some-new-content'
        }
        expect do
          put :store, authorized_api_params.merge(content_block: new_content_block)
        end.not_to change { ContentBlock.count }

        expect(response).to have_http_status(:ok)
        expect(assigns(:content_block)).to eq(content_block)
        expect(ContentBlock.first.content).to eq(new_content_block[:content])
      end

      it 'blocks when the private api key is non-existent' do
        unauthorized_api_params = { api_key: content_block.api_key, private_api_key: 'non-existent-private-api-key' }
        put :store, unauthorized_api_params
        expect(assigns(:content_block)).to be_nil
        expect(response).to have_http_status(:unauthorized)
      end

      it 'does not find a resource' do
        invalid_authorized_api_params = { api_key: 'non-exist', private_api_key: credential_pair.private_api_key }
        put :store, invalid_authorized_api_params
        expect(assigns(:content_block)).to be_nil
        expect(response).to have_http_status(:unauthorized)
      end

      it 'stores the block when the predecessor version matches the latest version of the block' do
        params = merged_params
        params[:content_block][:version] = content_block.version
        put :store, params
        expect(assigns(:content_block)).to eq(content_block)
        expect(response).to have_http_status(:success)
      end

      it 'raises an error 409 when the predecessor version is outdated' do
        outdated_version = content_block.version
        content_block.update(content: 'I update the block, before you do. Muahahaha!')
        params = merged_params
        params[:content_block][:version] = outdated_version
        put :store, params
        expect(assigns(:content_block)).to be_nil
        expect(response).to have_http_status(409)
      end
    end
  end
end
