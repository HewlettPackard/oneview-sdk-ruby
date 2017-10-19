require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::Switch do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::Switch
  end

  describe '#set_scope_uris' do
    it 'does a PATCH containing the scope uris to a switch' do
      item = described_class.new(@client_300, uri: '/rest/fake')
      data = { 'body' => [{ 'op' => 'replace', 'path' => '/scopeUris', 'value' => ['/rest/scopes/fee00629-9931-426d-8771-a597917eb9d2'] }] }
      expect(@client_300).to receive(:rest_patch).with('/rest/fake', data, item.api_version).and_return(FakeResponse.new(key: 'Val'))
      expect(item.set_scope_uris(['/rest/scopes/fee00629-9931-426d-8771-a597917eb9d2'])).to eq('key' => 'Val')
    end
  end

  describe '#update_port' do
    it 'updates a port' do
      options = {
        'uri' => '/rest/fake',
        'ports' => [
          {
            'portName' => 'port1',
            'enabled' => true
          }
        ]
      }

      options_2 = {
        'portName' => 'port1',
        'enabled' => false
      }

      item = described_class.new(@client_300, options)
      fake_response = FakeResponse.new
      expect(@client_300).to receive(:rest_put).with('/rest/fake/update-ports', 'body' => [options_2]).and_return(fake_response)
      expect(@client_300).to receive(:response_handler).with(fake_response).and_return(options_2)
      res = item.update_port('port1', enabled: false)
      expect(res['name']).to eq(options_2['name'])
      expect(res['enabled']).to eq(options_2['enabled'])
    end
  end
end
