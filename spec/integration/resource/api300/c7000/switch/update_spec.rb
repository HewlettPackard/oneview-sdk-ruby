require 'spec_helper'

klass = OneviewSDK::API300::C7000::Switch
RSpec.describe klass, integration: true, type: UPDATE do
  let(:current_client) { $client_300 }
  include_examples 'SwitchUpdateExample', 'integration api300 context'
  include_examples 'SwitchUpdateExample  API300', 'integration api300 context'

  describe '#set_scope_uris' do
    it 'replaces the switch scopeUris' do
      scope_1 = OneviewSDK::API300::C7000::Scope.get_all($client_300)[0]
      scope_2 = OneviewSDK::API300::C7000::Scope.get_all($client_300)[1]

      scope_uris = scope_1['uri'], scope_2['uri']
      expect { item.set_scope_uris(scope_uris) }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['scopeUris']).to match_array([scope_1['uri'], scope_2['uri']])

      expect { item.set_scope_uris([]) }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['scopeUris']).to be_empty
    end
  end

  include_examples 'ScopeHelperMethodsExample', OneviewSDK::API300::C7000::Scope do
    let(:item) { described_class.find_by(current_client, name: $secrets['logical_switch1_ip']).first }
  end
end
