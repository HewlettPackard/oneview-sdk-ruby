require 'spec_helper'

klass = OneviewSDK::API300::C7000::ServerProfileTemplate
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#create' do
    it 'can create a basic connection-less server profile template' do
      item = OneviewSDK::API300::C7000::ServerProfileTemplate.new($client_300, name: SERVER_PROFILE_TEMPLATE_NAME)
      server_hardware_type = OneviewSDK::API300::C7000::ServerHardwareType.find_by($client_300, {}).first
      enclosure_group = OneviewSDK::API300::C7000::EnclosureGroup.find_by($client_300, {}).first
      item.set_server_hardware_type(server_hardware_type)
      item.set_enclosure_group(enclosure_group)
      expect { item.create }.to_not raise_error
      expect(item['uri']).to be
    end
  end

  describe '#new_profile' do
    it 'returns a profile' do
      item = OneviewSDK::API300::C7000::ServerProfileTemplate.new($client_300, name: SERVER_PROFILE_TEMPLATE_NAME)
      item.retrieve!
      profile = item.new_profile
      expect(profile.class).to eq(OneviewSDK::API300::C7000::ServerProfile)
      expect { profile.create }.not_to raise_error
      expect(profile['uri']).to be
    end
  end
end
