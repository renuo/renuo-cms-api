require 'rails_helper'

# TODO: rewrite the parameter tests (non-existing-resource, unauthorized) as shared examples
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
        expect(response).to have_http_status(:ok)
        expect(response.body).to eq(content_block.to_json)
      end

      it 'leads to failure without corresponding resource' do
        get :show, invalid_default_api_params
        expect(assigns(:content_block)).to be_nil
        expect(response).to have_http_status(:not_found)
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

    # Left here for better understanding: There are no tests for this combination.
    # let(:invalid_unauthorized_api_params) do
    #   invalid_default_api_params.merge(private_api_key: 'non-existent-private-api-key')
    # end

    describe 'POST create' do
      it 'checks wether a record gets created when posting JSON' do
        content_block_attributes = attributes_for(:content_block)
        expect do
          post :create, authorized_api_params.merge(content_block: content_block_attributes)
        end.to change { ContentBlock.count }.by(1)
        expect(response).to have_http_status(:created)
      end

      it 'blocks upon wrong credentials' do
        post :create, unauthorized_api_params
        expect(assigns(:content_block)).to be_nil
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'PATCH update' do
      it 'checks wether a record gets created when posting JSON' do
        new_content_block = {
          api_key: content_block.api_key,
          content: 'foo baz'
        }
        patch :update, authorized_api_params.merge(content_block: new_content_block)
        expect(response).to have_http_status(:ok)
        expect(assigns(:content_block)).to eq(content_block)
        expect(ContentBlock.first.content).to eq(new_content_block[:content])
      end

      it 'doesnt find a resource' do
        patch :update, invalid_authorized_api_params
        expect(assigns(:content_block)).to be_nil
        expect(response).to have_http_status(:not_found)
      end

      it 'blocks upon wrong credentials' do
        patch :update, unauthorized_api_params
        expect(assigns(:content_block)).to eq(content_block)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe 'DELETE destroy' do
      it 'checks whether a record can be deleted' do
        delete :destroy, authorized_api_params
        expect(response).to have_http_status(:ok)
        expect(assigns(:content_block)).to eq(content_block)
        expect(ContentBlock.count).to be 0
      end

      it 'doesnt find a resource' do
        delete :destroy, invalid_authorized_api_params
        expect(assigns(:content_block)).to be_nil
        expect(response).to have_http_status(:not_found)
      end

      it 'blocks upon wrong credentials' do
        delete :destroy, unauthorized_api_params
        expect(assigns(:content_block)).to eq(content_block)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
