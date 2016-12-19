require 'spec_helper'

klass = OneviewSDK::ServerHardwareType
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration context'

  let(:server_hardware) do
    OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware2_ip']).first
  end
  subject(:target) { klass.find_by($client, uri: server_hardware['serverHardwareTypeUri']).first }

  describe '#update' do
    it 'should update name and description' do
      expect { target.update(name: 'Name Updated', description: 'Description updated') }.not_to raise_error

      target.retrieve!

      expect(target['name']).to eq('Name Updated')
      expect(target['description']).to eq('Description updated')
    end
  end
end
