require 'rails_helper'

RSpec.describe V1::ContentBlocksController, type: :controller do
  let!(:content_block) { create(:content_block) }

  def etag_and_last_modified_available?
    expect(response.headers['ETag']).to be_truthy
    expect(response.headers['Last-Modified']).to be_truthy
  end

  def set_request_env_variables(etag, last_modified)
    request.env['HTTP_IF_NONE_MATCH'] = etag
    request.env['HTTP_IF_MODIFIED_SINCE'] = last_modified
  end

  def compare_content_block(expected_content_block, raw_content_block)
    content_block = OpenStruct.new(raw_content_block)

    expect(content_block.content).to eq(expected_content_block.content)
    expect(content_block.content_path).to eq(expected_content_block.content_path)
    expect(content_block.api_key).to eq(expected_content_block.api_key)
    expect(content_block.id).to be_nil
  end
  context 'requesting a content block' do
    describe 'GET index' do
      before(:all) do
        Rails.cache.clear
      end

      def check_object(blocks, index, content_block)
        compare_content_block(content_block, blocks[index])
      end

      it 'returns the right JSON content' do
        content_block2 = create(:content_block, api_key: content_block.api_key)
        create(:content_block, api_key: 'some-other-key')
        get :index, api_key: content_block.api_key
        content_blocks = assigns(:content_blocks_json)['content_blocks']
        expect(content_blocks.size).to eq(2)
        compare_content_block(content_block, content_blocks[0])
        compare_content_block(content_block2, content_blocks[1])
        expect(response).to have_http_status(:ok)

        blocks = JSON.parse(response.body)['content_blocks']
        expect(blocks.size).to eq(2)
        check_object(blocks, 0, content_block)
        check_object(blocks, 1, content_block2)
      end

      describe 'cache behaviour' do
        context 'on the first request' do
          it 'loads the content-blocks and returns a 200' do
            get :index, api_key: content_block.api_key
            expect(response).to have_http_status 200
            etag_and_last_modified_available?
          end
        end

        context 'on a subsequent request' do
          before do
            get :index, api_key: content_block.api_key
            expect(response).to have_http_status 200
            etag_and_last_modified_available?
            @etag = response.headers['ETag']
            @last_modified = response.headers['Last-Modified']
          end

          context 'if it is not stale' do
            before { set_request_env_variables(@etag, @last_modified) }

            it 'returns only the etag with the 304 status code' do
              get :index, api_key: content_block.api_key
              expect(response).to have_http_status 304
            end

            it 'returns still a 304 if a content_block from another api_key has been updated' do
              create(:content_block, updated_at: 3.days.since, api_key: 'anotherAPIKey')
              get :index, api_key: content_block.api_key
              expect(response).to have_http_status 304
            end
          end

          context 'if it has been updated' do
            before do
              content_block.updated_at = 10.days.since
              content_block.save
              set_request_env_variables(@etag, @last_modified)
            end

            it 'reloads content-blocks and returns a 200 status code' do
              get :index, api_key: content_block.api_key
              expect(response).to have_http_status 200
            end
          end
        end
      end
    end

    describe 'GET fetch' do
      it 'checks whether the right JSON responds to a GET request to a show action' do
        get :fetch, api_key: content_block.api_key, content_path: content_block.content_path
        expect(assigns(:content_block)).to eq(content_block)
        expect(assigns(:content_block).created_at).to be_within(5.seconds).of(content_block.created_at)
        expect(response).to have_http_status(:ok)
        object = JSON.parse(response.body)['content_block']
        compare_content_block(content_block, object)
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

      describe 'cache behaviour' do
        context 'on the first request' do
          it 'loads the content-blocks and returns a 200' do
            get :fetch, api_key: content_block.api_key, content_path: content_block.content_path
            expect(response).to have_http_status 200
            etag_and_last_modified_available?
          end
        end

        context 'on a subsequent request' do
          before do
            get :fetch, api_key: content_block.api_key, content_path: content_block.content_path
            expect(response).to have_http_status 200
            etag_and_last_modified_available?
            @etag = response.headers['ETag']
            @last_modified = response.headers['Last-Modified']
          end

          context 'if it is not stale' do
            before { set_request_env_variables(@etag, @last_modified) }

            it 'returns only the etag with the 304 status code' do
              get :fetch, api_key: content_block.api_key, content_path: content_block.content_path
              expect(response).to have_http_status 304
            end

            it 'returns still a 304 if a content_block from another api_key has been updated' do
              create(:content_block, updated_at: 3.days.since, api_key: 'anotherAPIKey')
              get :fetch, api_key: content_block.api_key, content_path: content_block.content_path
              expect(response).to have_http_status 304
            end
          end

          context 'if it has been updated' do
            before do
              content_block.updated_at = 10.days.since
              content_block.save
              set_request_env_variables(@etag, @last_modified)
            end

            it 'reloads content-blocks and returns a 200 status code' do
              get :fetch, api_key: content_block.api_key, content_path: content_block.content_path
              expect(response).to have_http_status 200
            end
          end
        end
      end
    end
  end

  context 'changing a content block' do
    let!(:credential_pair) { create(:credential_pair, api_key: content_block.api_key) }
    let(:authorized_api_params) { { api_key: content_block.api_key, private_api_key: credential_pair.private_api_key } }

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
    end
  end

  describe '#unhashed_etag' do
    it 'creates a string, which contains the api key and the time of the last modified contentblock' do
      unauthorized_api_params = { api_key: content_block.api_key, private_api_key: 'non-existent-private-api-key' }
      put :store, unauthorized_api_params
      expect(assigns(:content_block)).to be_nil
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
