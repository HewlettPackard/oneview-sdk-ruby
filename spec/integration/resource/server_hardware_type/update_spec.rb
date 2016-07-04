require 'spec_helper'

RSpec.describe OneviewSDK::ServerHardwareType, integration: true, type: UPDATE do
  include_context 'integration context'

  before :each do
    server_hardware = OneviewSDK::ServerHardware.find_by($client, name: $secrets['server_hardware2_ip']).first
    puts server_hardware['model']
    @item = OneviewSDK::ServerHardwareType.find_by($client, model: server_hardware['model']).first
  end

  describe '#update' do
    it 'Update name and description' do
      old_name = @item['name']
      expect { @item.update(name: 'Test', description: 'Server hardware type description') }.not_to raise_error
      @item.update(name: old_name)
    end
  end

end
