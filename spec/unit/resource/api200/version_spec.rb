require 'spec_helper'

RSpec.describe OneviewSDK::Version do
  include_context 'shared context'
  describe '#get_version' do
    it 'calls the uri' do
      expect(@client_200).to receive(:rest_get).with(described_class::BASE_URI).and_return(FakeResponse.new(members: []))
      described_class.get_version(@client_200)
    end
  end
end
