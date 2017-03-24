require 'spec_helper'

klass = OneviewSDK::API300::C7000::Switch
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:scope_1) { OneviewSDK::API300::C7000::Scope.get_all($client_300)[0] }
  let(:scope_2) { OneviewSDK::API300::C7000::Scope.get_all($client_300)[1] }
  let(:scope_clean) { OneviewSDK::API300::C7000::Scope.new($client_300) }
  subject(:item) { klass.find_by($client_300, {}).first }

  describe '#set_scope_uris' do
    it 'replaces the switch scopeUris' do
      scope_uris = scope_1['uri'], scope_2['uri']
      expect { item.set_scope_uris(scope_uris) }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['scopeUris']).to match_array([scope_1['uri'], scope_2['uri']])

      expect { item.set_scope_uris([]) }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['scopeUris']).to be_empty
    end
  end

  describe '#add_scope' do
    context 'when scope has no URI' do
      it { expect { item.add_scope(scope_clean) }.to raise_error(OneviewSDK::IncompleteResource) }
    end

    it 'should add scope' do
      expect { item.add_scope(scope_1) }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['scopeUris']).to match_array([scope_1['uri']])
    end
  end

  describe '#replace_scopes' do
    context 'when scope has no URI' do
      it { expect { item.replace_scopes(scope_clean) }.to raise_error(OneviewSDK::IncompleteResource) }
    end

    it 'should replace the list of scopes' do
      expect { item.replace_scopes(scope_1, scope_2) }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['scopeUris']).to match_array([scope_1['uri'], scope_2['uri']])
    end
  end

  describe '#remove_scope' do
    context 'when scope has no URI' do
      it { expect { item.remove_scope(scope_clean) }.to raise_error(OneviewSDK::IncompleteResource) }
    end

    it 'should remove scope' do
      expect { item.remove_scope(scope_2) }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['scopeUris']).to match_array([scope_1['uri']]) # scope_2 was removed

      expect { item.remove_scope(scope_1) }.to_not raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['scopeUris']).to be_empty
    end
  end
end
