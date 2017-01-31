require 'spec_helper'

klass = OneviewSDK::API300::C7000::Enclosure
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:scope_1) { OneviewSDK::API300::C7000::Scope.get_all($client_300)[0] }
  let(:scope_2) { OneviewSDK::API300::C7000::Scope.get_all($client_300)[1] }
  let(:scope_clean) { OneviewSDK::API300::C7000::Scope.new($client_300) }
  subject(:item) { klass.find_by($client_300, name: ENCL_NAME).first }

  describe '#update' do
    it 'Changes name' do
      item.update(name: ENCL_NAME_UPDATED)
      expect(item[:name]).to eq(ENCL_NAME_UPDATED)
      item.update(name: ENCL_NAME) # Put it back to normal
      expect(item[:name]).to eq(ENCL_NAME)
    end
  end

  describe '#configuration' do
    it 'update OneViewSDK_Int_Ethernet_Network name' do
      expect { item.configuration }.not_to raise_error
    end
  end

  describe '#refreshState' do
    it 'returns all resources when the hash is empty' do
      expect { item.set_refresh_state('RefreshPending') }.not_to raise_error
    end
  end

  describe '#patch' do
    it 'replaces the enclosure name and sets it back to the original' do
      expect { item.patch('replace', '/name', ENCL_NAME_UPDATED) }.not_to raise_error
      item.retrieve!
      expect(item['name']).to eq(ENCL_NAME_UPDATED)
      expect { item.patch('replace', '/name', ENCL_NAME) }.not_to raise_error
      item.retrieve!
      expect(item['name']).to eq(ENCL_NAME)
    end
  end

  describe '#add_scope' do
    context 'when scope has not uri' do
      it { expect { item.add_scope(scope_clean) }.to raise_error(OneviewSDK::IncompleteResource) }
    end

    it 'should add scope' do
      expect { item.add_scope(scope_1) }.to_not raise_error
      item.refresh
      expect(item['scopeUris']).to match_array([scope_1['uri']])
    end
  end

  describe '#replace_scopes' do
    context 'when scope has not uri' do
      it { expect { item.replace_scopes(scope_clean) }.to raise_error(OneviewSDK::IncompleteResource) }
    end

    it 'should replace the list of scopes' do
      expect { item.replace_scopes(scope_1, scope_2) }.to_not raise_error
      item.refresh
      expect(item['scopeUris']).to match_array([scope_1['uri'], scope_2['uri']])
    end
  end

  describe '#remove_scope' do
    context 'when scope has not uri' do
      it { expect { item.remove_scope(scope_clean) }.to raise_error(OneviewSDK::IncompleteResource) }
    end

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
