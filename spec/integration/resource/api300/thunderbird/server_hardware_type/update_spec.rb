require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::ServerHardwareType
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:server_hardware) do
    OneviewSDK::API300::Thunderbird::ServerHardware.get_all($client_300_thunderbird).first
  end
  subject(:target) { klass.find_by($client_300_thunderbird, uri: server_hardware['serverHardwareTypeUri']).first }

  describe '#update' do
    it 'should update name and description' do
      expect { target.update(name: 'Name Updated', description: 'Description updated') }.not_to raise_error

      target.retrieve!

      expect(target['name']).to eq('Name Updated')
      expect(target['description']).to eq('Description updated')
    end
  end
end
