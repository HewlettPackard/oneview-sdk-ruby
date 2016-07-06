require 'spec_helper'

RSpec.describe OneviewSDK::SANManager, integration: true, type: UPDATE do
  include_context 'integration context'

  before :each do
    @item = OneviewSDK::SANManager.new($client, name: $secrets['san_manager_ip'])
    @item.retrieve!
  end

  describe '#update' do
    it 'refresh a SAN Device Manager' do
      expect { @item.update(refreshState: 'RefreshPending') }.not_to raise_error
    end

    it 'Update hostname and credentials' do
      connection_info = [
        {
          'name' => 'Host',
          'value' => $secrets['san_manager_ip']
        },
        {
          'name' => 'Username',
          'value' => $secrets['san_manager_username']
        },
        {
          'name' => 'Password',
          'value' => $secrets['san_manager_password']
        }
      ]
      expect { @item.update(connectionInfo: connection_info) }.not_to raise_error
    end

    it 'Update invalid field' do
      expect { @item.update(name: 'SANManager_01') }.to raise_error(OneviewSDK::BadRequest)
    end
  end
end
