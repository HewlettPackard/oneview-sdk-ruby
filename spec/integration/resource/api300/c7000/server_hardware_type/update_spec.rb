require 'spec_helper'

klass = OneviewSDK::API300::C7000::ServerHardwareType
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:server_hardware) do
    OneviewSDK::API300::C7000::ServerHardware.find_by($client_300, name: $secrets['server_hardware2_ip']).first
  end
  subject(:target) { klass.find_by($client_300, uri: server_hardware['serverHardwareTypeUri']).first }

  describe '#update' do
    it 'should update name and description' do
      expect { target.update(name: 'Name Updated', description: 'Description updated') }.not_to raise_error

      target.retrieve!

      expect(target['name']).to eq('Name Updated')
      expect(target['description']).to eq('Description updated')
    end
  end
end
