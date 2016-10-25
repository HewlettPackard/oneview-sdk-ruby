require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalEnclosure
extra_klass_1 = OneviewSDK::API300::C7000::EnclosureGroup
extra_klass_2 = OneviewSDK::API300::C7000::Enclosure
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:enclosure_group_options) do
    {
      'name' => ENC_GROUP2_NAME,
      'stackingMode' => 'Enclosure',
      'type' => 'EnclosureGroupV300'
    }
  end

  let(:enclosure_options) do
    {
      'hostname' => $secrets['enclosure1_ip'],
      'username' => $secrets['enclosure1_user'],
      'password' => $secrets['enclosure1_password'],
      'licensingIntent' => 'OneView',
      'name' => ENCL_NAME
    }
  end

  let(:value) do
    {
      firmwareUpdateOn: 'SharedInfrastructureOnly',
      forceInstallFirmware: false,
      updateFirmwareOnUnmanagedInterconnect: true
    }
  end

  describe '#patch' do
    it 'Update a given logical enclosure' do
      enclosure_group = extra_klass_1.new($client_300, enclosure_group_options)
      enclosure_group.delete if enclosure_group.retrieve!
      enclosure_group.create
      enclosure_group.retrieve!
      enclosure = extra_klass_2.new($client_300, enclosure_options)
      enclosure.set_enclosure_group(enclosure_group)
      enclosure.add

      item = klass.find_by($client_300, {}).first
      response = nil
      expect { response = item.patch(value) }.to_not raise_error
      expect(response['uri']).to eq(item['uri'])
      expect(response['name']).to eq(item['name'])
    end
  end
end
