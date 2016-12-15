require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::ServerProfileTemplate, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :all do
    @item = OneviewSDK::API300::Synergy::ServerProfileTemplate.new($client_300_synergy, name: SERVER_PROFILE_TEMPLATE_NAME)
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
      server_hardware_type = OneviewSDK::API300::Synergy::ServerHardwareType.find_by($client_300_synergy, {}).first
      enclosure_group = OneviewSDK::API300::Synergy::EnclosureGroup.find_by($client_300_synergy, {}).first
      expect do
        @item.get_transformation($client_300_synergy,
                                 'server_hardware_type' => server_hardware_type,
                                 'enclosure_group' => enclosure_group)
      end.to_not raise_error
    end
  end
end
