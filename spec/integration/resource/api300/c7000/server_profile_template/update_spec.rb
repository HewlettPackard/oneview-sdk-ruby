require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::ServerProfileTemplate, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :all do
    @item = OneviewSDK::API300::C7000::ServerProfileTemplate.new($client_300, name: SERVER_PROFILE_TEMPLATE_NAME)
  end

  describe '#update' do
    it 'updates the name attribute' do
      @item.retrieve!
      expect { @item.update(name: SERVER_PROFILE_TEMPLATE_NAME_UPDATED) }.not_to raise_error
      expect(@item.retrieve!).to be
      expect { @item.update(name: SERVER_PROFILE_TEMPLATE_NAME) }.not_to raise_error
      expect(@item.retrieve!).to be
      expect(@item['name']).to eq(SERVER_PROFILE_TEMPLATE_NAME)
    end
  end

  describe '#get_transformation' do
    it 'transforms an existing profile' do
      server_hardware_type = OneviewSDK::API300::C7000::ServerHardwareType.find_by($client_300, {}).first
      enclosure_group = OneviewSDK::API300::C7000::EnclosureGroup.find_by($client_300, {}).first
      expect { @item.get_transformation($client_300, 'server_hardware_type' => server_hardware_type, 'enclosure_group' => enclosure_group) }
        .to_not raise_error
    end
  end
end
