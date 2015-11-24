require 'rails_helper'

RSpec.describe Api::ContentBlocksController, type: :controller do
  render_views

  let!(:content_block) { create(:content_block) }

  let(:default_api_params) do
    {
      format: :json,
      api_key: content_block.api_key,
      content_path: content_block.content_path
    }
  end

  let(:invalid_default_api_params) do
    {
      format: :json,
      api_key: 'non-existing-api-key',
      content_path: 'non-existing-content-path'
    }
  end

  context 'requesting a content block' do
    describe 'GET show' do
      it 'checks whether the right JSON responds to a GET request to a show action' do
        get :show, default_api_params
        expect(assigns(:content_block)).to eq(content_block)
        expect(assigns(:content_block).created_at).to eq(content_block.created_at)
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(content_block.to_json)
      end

      it 'renders return an empty content without corresponding resource' do
        get :show, invalid_default_api_params
        content_block = assigns(:content_block)
        expect(content_block.created_at).to be_nil
        expect(content_block.content).to eq('')
        expect(content_block.api_key).to eq(invalid_default_api_params[:api_key])
        expect(content_block.content_path).to eq('non-existing-content-path')
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'changing a content block' do
    let!(:credential_pair) do
      create(:credential_pair, api_key: content_block.api_key)
    end

    let(:authorized_api_params) do
      default_api_params.merge(private_api_key: credential_pair.private_api_key)
    end

    let(:invalid_authorized_api_params) do
      invalid_default_api_params.merge(private_api_key: credential_pair.private_api_key)
    end

    let(:unauthorized_api_params) do
      default_api_params.merge(private_api_key: 'non-existent-private-api-key')
    end

    describe 'update' do
      it 'checks whether a record gets created when posting JSON' do
        expect do
          post :update, authorized_api_params.merge(content_path: 'new-content',
                                                    content_block: { content: 'new content!' })
        end.to change { ContentBlock.count }.by(1)

        expect(ContentBlock.last.content).to eq('new content!')
        expect(response).to have_http_status(:ok)
      end

      it 'blocks upon wrong credentials' do
        post :update, unauthorized_api_params
        expect(assigns(:content_block)).to be_nil
        expect(response).to have_http_status(:unauthorized)
      end

      it 'checks whether a record gets created when posting JSON' do
        new_content_block = {
          api_key: content_block.api_key,
          content: 'foo baz'
        }
        post :update, authorized_api_params.merge(content_block: new_content_block)
        expect(response).to have_http_status(:ok)
        expect(assigns(:content_block)).to eq(content_block)
        expect(ContentBlock.first.content).to eq(new_content_block[:content])
      end

      it 'does not find a resource' do
        post :update, invalid_authorized_api_params
        expect(assigns(:content_block)).to be_nil
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
