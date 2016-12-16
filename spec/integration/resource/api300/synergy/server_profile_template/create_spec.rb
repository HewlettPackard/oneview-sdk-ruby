require 'spec_helper'

klass = OneviewSDK::API300::Synergy::ServerProfileTemplate
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  describe '#create' do
    it 'can create a basic connection-less server profile template' do
      item = OneviewSDK::API300::Synergy::ServerProfileTemplate.new($client_300_synergy, name: SERVER_PROFILE_TEMPLATE_NAME)
      server_hardware_type = OneviewSDK::API300::Synergy::ServerHardwareType.find_by($client_300_synergy, {}).first
      enclosure_group = OneviewSDK::API300::Synergy::EnclosureGroup.find_by($client_300_synergy, {}).first
      item.set_server_hardware_type(server_hardware_type)
      item.set_enclosure_group(enclosure_group)
      expect { item.create }.to_not raise_error
      expect(item['uri']).to be
    end
  end

  describe '#new_profile' do
    it 'returns a profile' do
      item = OneviewSDK::API300::Synergy::ServerProfileTemplate.new($client_300_synergy, name: SERVER_PROFILE_TEMPLATE_NAME)
      item.retrieve!
      profile = item.new_profile
      expect(profile.class).to eq(OneviewSDK::API300::ServerProfile)
      expect { profile.create }.not_to raise_error
      expect(profile['uri']).to be
    end
  end
end
