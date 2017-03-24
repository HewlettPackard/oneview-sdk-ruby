require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalSwitch
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:scope_1) { OneviewSDK::API300::C7000::Scope.get_all($client_300)[0] }
  let(:scope_2) { OneviewSDK::API300::C7000::Scope.get_all($client_300)[1] }
  subject(:item) { klass.find_by($client_300, name: LOG_SWI_NAME).first }

  describe '#refresh_state' do
    it 'should reclaims the top-of-rack switches in a logical switch' do
      expect { item.refresh_state }.to_not raise_error
    end
  end

  describe '#add_scope' do
    it 'should add scope' do
      expect { item.add_scope(scope_1) }.to_not raise_error
      item.refresh
      expect(item['scopeUris']).to match_array([scope_1['uri']])
    end
  end

  describe '#replace_scopes' do
    it 'should replace the list of scopes' do
      expect { item.replace_scopes(scope_1, scope_2) }.to_not raise_error
      item.refresh
      expect(item['scopeUris']).to match_array([scope_1['uri'], scope_2['uri']])
    end
  end

  describe '#remove_scope' do
    it 'should remove scope' do
      expect { item.remove_scope(scope_2) }.to_not raise_error
      item.refresh
      expect(item['scopeUris']).to match_array([scope_1['uri']]) # scope_2 was removed

      expect { item.remove_scope(scope_1) }.to_not raise_error
      item.refresh
      expect(item['scopeUris']).to be_empty
    end
  end
end
