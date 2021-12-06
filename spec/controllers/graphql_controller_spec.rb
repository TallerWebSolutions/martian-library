# frozen_string_literal: true

RSpec.describe GraphqlController, type: :controller do
  context 'when unauthorized' do
    it 'returns not found' do
      post :execute, params: { format: :json, query: '{}' }
      expect(response).to have_http_status :not_found
      expect(JSON.parse(response.body)['message']).to eq 'Not Found'
    end
  end

  context 'when authorized' do
    let(:query) do
      '{
  items {
    id
    title
    user {
      id
      email
    }
  }
}'
    end

    context 'with valid data' do
      it 'returns the query result' do
        user = FactoryBot.create(:user)
        item = FactoryBot.create(:item, user: user)

        request.headers['Authorization'] = Base64.encode64(user.email)
        post :execute, params: { format: :json, query: query }

        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)).to eq({ 'data' => { 'items' => [{ 'id' => item.id.to_s, 'title' => item.title.to_s,
                                                                            'user' => { 'id' => user.id.to_s, 'email' => user.email.to_s } }] } })
      end
    end

    context 'without valid data' do
      it 'returns an empty query result' do
        user = FactoryBot.create(:user)

        request.headers['Authorization'] = Base64.encode64(user.email)
        post :execute, params: { format: :json, query: query }

        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)).to eq({ 'data' => { 'items' => [] } })
      end
    end
  end
end
