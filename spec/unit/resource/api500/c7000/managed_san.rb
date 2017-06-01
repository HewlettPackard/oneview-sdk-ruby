require 'spec_helper'

RSpec.describe OneviewSDK::API500::C7000::ManagedSAN do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::C7000::ManagedSAN' do
    expect(described_class).to be < OneviewSDK::API300::C7000::ManagedSAN
  end

  describe '#set_public_attributes' do
    it 'Update public attributes' do
      attributes = [
        {
          name: 'MetaSan',
          value: 'Neon SAN',
          valueType: 'String',
          valueFormat: 'None'
        }
      ]
      item = described_class.new(@client_500, uri: '/rest/fc-sans/managed-sans/100')
      fake_response = FakeResponse.new
      expect(@client_500).to receive(:rest_put)
        .with('/rest/fc-sans/managed-sans/100', 'body' => { publicAttributes: attributes }).and_return(fake_response)
      expect(@client_500).to receive(:response_handler).with(fake_response).and_return('fake')
      expect(item.set_public_attributes(attributes)).to eq('fake')
    end
  end
end
