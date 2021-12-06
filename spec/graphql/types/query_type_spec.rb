# frozen_string_literal: true

RSpec.describe Types::QueryType do
  describe 'items' do
    subject(:result) do
      MartianLibrarySchema.execute(query).as_json
    end

    let!(:items) { create_pair(:item) }

    describe '#items' do
      let(:query) do
        %(query {
        items {
          title
        }
      })
      end

      it 'returns all items' do
        expect(result.dig('data', 'items')).to match_array(
          items.map { |item| { 'title' => item.title } }
        )
      end
    end

    describe 'users' do
      let(:query) do
        %(query {
        users {
          fullName
        }
      })
      end

      it 'returns all users' do
        FactoryBot.create :user
        FactoryBot.create :user

        users = User.all

        expect(result.dig('data', 'users')).to match_array(
          users.map { |user| { 'fullName' => user.full_name } }
        )
      end
    end
  end
end
