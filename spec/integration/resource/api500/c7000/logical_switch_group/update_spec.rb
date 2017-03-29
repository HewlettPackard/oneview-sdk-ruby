require 'spec_helper'

klass = OneviewSDK::API500::C7000::LogicalSwitchGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api500 context'

  let(:scope_1) { OneviewSDK::API500::C7000::Scope.get_all($client_500)[0] }
  let(:scope_2) { OneviewSDK::API500::C7000::Scope.get_all($client_500)[1] }
  subject(:item) { klass.find_by($client_500, name: LOG_SWI_GROUP_NAME).first }

  describe '#update' do
    it 'renaming the Logical Switch Group' do
      expect { item.update(name: LOG_SWI_GROUP_NAME_UPDATED) }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(LOG_SWI_GROUP_NAME_UPDATED)
      expect { item.update(name: LOG_SWI_GROUP_NAME) }.not_to raise_error
      item.retrieve!
      expect(item['uri']).to be
      expect(item['name']).to eq(LOG_SWI_GROUP_NAME)
    end
  end

  describe '#add_scope' do
    it 'should add scope' do
      expect { item.add_scope(scope_1) }.to_not raise_error
      sleep 5
      item.retrieve!
      expect(item['scopeUris']).to match_array([scope_1['uri']])
    end
  end

  describe '#replace_scopes' do
    it 'should replace the list of scopes' do
      expect { item.replace_scopes(scope_1, scope_2) }.to_not raise_error
      sleep 5
      item.retrieve!
      expect(item['scopeUris']).to match_array([scope_1['uri'], scope_2['uri']])
    end
  end

  describe '#remove_scope' do
    it 'should remove scope' do
      expect { item.remove_scope(scope_2) }.to_not raise_error
      sleep 5
      item.retrieve!
      expect(item['scopeUris']).to match_array([scope_1['uri']])

      expect { item.remove_scope(scope_1) }.to_not raise_error
      sleep 5
      item.retrieve!
      expect(item['scopeUris']).to be_empty
    end
  end
end
