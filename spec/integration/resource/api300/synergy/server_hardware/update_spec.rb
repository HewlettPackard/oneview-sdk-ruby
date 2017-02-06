require 'spec_helper'

klass = OneviewSDK::API300::Synergy::ServerHardware
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:scope_1) { OneviewSDK::API300::Synergy::Scope.get_all($client_300_synergy)[0] }
  let(:scope_2) { OneviewSDK::API300::Synergy::Scope.get_all($client_300_synergy)[1] }
  let(:scope_clean) { OneviewSDK::API300::Synergy::Scope.new($client_300_synergy) }
  subject(:item) { klass.get_all($client_300_synergy).first }

  describe '#set_refresh_state' do
    it 'Refresh state with no additional parameters' do
      expect { item.set_refresh_state('RefreshPending') }.not_to raise_error
    end

    it 'Refresh state with additional parameters' do
      expect { item.set_refresh_state('RefreshPending', resfreshActions: 'ClearSyslog') }.not_to raise_error
    end
  end

  describe '#power' do
    it 'Power off server hardware' do
      expect { item.power_off }.not_to raise_error
    end

    it 'Power on server hardware' do
      expect { item.power_on }.not_to raise_error
    end

    it 'Force power off server hardware' do
      expect { item.power_off(true) }.not_to raise_error
    end
  end

  describe '#update_ilo_firmware' do
    it 'Update iLO firmware to OneView minimum supported version' do
      expect { item.update_ilo_firmware }.not_to raise_error
    end
  end

  describe '#add_scope' do
    context 'when scope has no URI' do
      it { expect { item.add_scope(scope_clean) }.to raise_error(OneviewSDK::IncompleteResource) }
    end

    it 'should add scope' do
      expect { item.add_scope(scope_1) }.to_not raise_error
      item.refresh
      expect(item['scopeUris']).to match_array([scope_1['uri']])
    end
  end

  describe '#replace_scopes' do
    context 'when scope has no URI' do
      it { expect { item.replace_scopes(scope_clean) }.to raise_error(OneviewSDK::IncompleteResource) }
    end

    it 'should replace the list of scopes' do
      expect { item.replace_scopes(scope_1, scope_2) }.to_not raise_error
      item.refresh
      expect(item['scopeUris']).to match_array([scope_1['uri'], scope_2['uri']])
    end
  end

  describe '#remove_scope' do
    context 'when scope has no URI' do
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
