require 'spec_helper'

klass = OneviewSDK::API300::C7000::StorageSystem
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#set_refresh_state' do
    before :each do
      @storage = klass.new($client_300, 'credentials' => {})
      @storage['credentials']['ip_hostname'] = $secrets['storage_system1_ip']
      @storage.retrieve!
    end
    
    it 'Refresh state with no additional parameters' do
      expect { @storage.set_refresh_state('RefreshPending') }.not_to raise_error
    end

    it 'Refresh state with additional parameters' do
      expect { @storage.set_refresh_state('RefreshPending', resfreshActions: 'ClearSyslog') }.not_to raise_error
    end
  end
end
