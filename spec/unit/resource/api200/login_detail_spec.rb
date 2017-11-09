require 'spec_helper'

RSpec.describe OneviewSDK::LoginDetail do
  include_context 'shared context'
  describe '#get_login_details' do
    it 'calls the uri' do
      expect(@client_200).to receive(:rest_get).with(described_class::BASE_URI).and_return(FakeResponse.new(members: []))
      described_class.get_login_details(@client_200)
    end
  end
end
