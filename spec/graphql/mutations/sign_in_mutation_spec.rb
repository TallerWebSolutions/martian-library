# frozen_string_literal: true

RSpec.describe Mutations::SignInMutation do
  let(:user) { FactoryBot.create(:user) }

  describe 'token' do
    context 'with correct call' do
      it 'returns the token in the result' do
        result = described_class.new(object: nil, field: nil, context: { session: {} }).resolve(email: user.email)
        expect(result[:token]).to be_present
      end
    end

    context 'without any email' do
      it 'returns an empty result' do
        result = described_class.new(object: nil, field: nil, context: { session: {} }).resolve(email: nil)
        expect(result[:token]).to be_nil
      end

      context 'without a valid email' do
        it 'returns an empty result' do
          result = described_class.new(object: nil, field: nil, context: { session: {} }).resolve(email: 'foo@bar.com')
          expect(result[:token]).to be_nil
        end
      end
    end
  end
end
