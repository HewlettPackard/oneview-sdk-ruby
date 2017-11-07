require 'spec_helper'

RSpec.describe OneviewSDK::LoginDetail do
  include_context 'shared context'
  describe '#get_login_details' do
    it 'calls the uri' do
      allow(@client_200).to receive(:rest_get).with(described_class::BASE_URI, {})
    end
  end
end
