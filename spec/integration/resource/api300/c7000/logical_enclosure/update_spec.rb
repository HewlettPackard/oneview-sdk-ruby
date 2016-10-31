require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalEnclosure
extra_klass_1 = OneviewSDK::API300::C7000::EnclosureGroup
extra_klass_2 = OneviewSDK::API300::C7000::Enclosure
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:value) do
    {
      firmwareUpdateOn: 'SharedInfrastructureOnly',
      forceInstallFirmware: false,
      updateFirmwareOnUnmanagedInterconnect: true
    }
  end

  before :all do
    enclosure_group_options = {
      'name' => ENC_GROUP2_NAME,
      'stackingMode' => 'Enclosure',
      'type' => 'EnclosureGroupV300'
    }
    enclosure_options = {
      'hostname' => $secrets['enclosure1_ip'],
      'username' => $secrets['enclosure1_user'],
      'password' => $secrets['enclosure1_password'],
      'licensingIntent' => 'OneView',
      'name' => ENCL_NAME
    }
    enclosure_group = extra_klass_1.new($client_300, enclosure_group_options)
    enclosure_group.delete if enclosure_group.retrieve!
    enclosure_group.create
    enclosure_group.retrieve!
    enclosure = extra_klass_2.new($client_300, enclosure_options)
    enclosure.set_enclosure_group(enclosure_group)
    enclosure.add
  end

  before :each do
    @item = klass.find_by($client_300, {}).first
  end

  describe '#reconfigure' do
    it 'Reconfigure logical enclosure' do
      expect { @item.reconfigure }.to_not raise_error
    end
  end

  describe '#update_from_group' do
    it 'Update logical enclosure from group' do
      expect { @item.update_from_group }.to_not raise_error
    end
  end

  describe '#script' do
    it 'can retrieve the script' do
      script = @item.get_script
      expect(script).to be_a(String)
    end

    it 'can set the script' do
      @item.set_script('#TEST COMMAND')
      expect(@item.get_script.tr('"', '')).to eq('#TEST COMMAND')
    end
  end

  describe '#support_dump' do
    it 'Support dump successfully' do
      expect { @item.support_dump(errorCode: 'test') }.to_not raise_error
    end
    it 'Raises exception when encrypt is false' do
      expect { @item.support_dump(errorCode: 'test', encrypt: false) }
        .to raise_error(/unexpected problem creating the logical enclosure support dump/)
    end
  end

  describe '#patch' do
    it 'Update a given logical enclosure across a patch' do
      response = nil
      expect { response = @item.patch(value) }.to_not raise_error
      expect(response['uri']).to eq(@item['uri'])
      expect(response['name']).to eq(@item['name'])
    end
  end
end
