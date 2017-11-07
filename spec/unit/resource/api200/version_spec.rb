require 'spec_helper'

RSpec.describe OneviewSDK::Version do
  include_context 'shared context'
  describe '#get_version' do
    it 'calls the uri' do
      allow(@client_200).to receive(:rest_get).with(described_class::BASE_URI, {})
    end
  end
end
