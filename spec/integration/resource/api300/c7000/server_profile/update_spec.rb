require 'spec_helper'

klass = OneviewSDK::API300::C7000::ServerProfile
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :all do
    @item = klass.new($client_300, name: SERVER_PROFILE_NAME)
    @item.retrieve!
    @enclosure_group = OneviewSDK::API300::C7000::EnclosureGroup.find_by($client_300, name: ENC_GROUP_NAME).first
    @server_hardware_type = OneviewSDK::API300::C7000::ServerHardwareType.find_by($client_300, {}).first
    @storage_system = OneviewSDK::API300::C7000::StorageSystem.find_by($client_300, {}).first
    @item3 = klass.new($client_300, name: SERVER_PROFILE2_NAME)
    @item3.retrieve!
  end

  describe '#set_enclosure_group' do
    it 'sets the enclosure group' do
      expect { @item.set_enclosure_group(@enclosure_group) }.to_not raise_error
      expect(@item['enclosureGroupUri']).to eq(@enclosure_group['uri'])
    end
  end

  describe '#get_server_hardware' do
    it 'retrieves the current server hardware' do
      expect { @item.get_server_hardware }.to_not raise_error
    end
  end

  describe '#get_available_hardware' do
    it 'retrieves the available hardware' do
      expect { @item.get_available_hardware }.to_not raise_error
    end
  end

  describe '#add_volume_attachment' do
    it 'adds a new volume to the server profile' do
      volume_attachment = OneviewSDK::API300::C7000::Volume.find_by($client_300, {}).first
      expect { @item.add_volume_attachment(volume_attachment) }.to_not raise_error
    end
  end

  describe '#remove_connection' do
    it 'removes a connection from the server profile' do
      expect { @item.remove_connection(ETH_NET_NAME) }.not_to raise_error
    end
  end

  describe '#self.get_available_networks' do
    it 'retrieves available networks without errors' do
      query_options = {
        'enclosure_group' => @enclosure_group,
        'server_hardware_type' => @server_hardware_type
      }
      expect { klass.get_available_networks($client_300, query_options) }.to_not raise_error
    end
  end

  describe '#self.get_available_servers' do
    it 'retrieves available servers without errors' do
      expect { klass.get_available_servers($client_300) }.to_not raise_error
    end
  end

  describe '#self.get_available_storage_system' do
    it 'retrieves available storage system without errors. FAIL: Bug in OneView/Documentation' do
      query_options = {
        'enclosure_group' => @enclosure_group,
        'server_hardware_type' => @server_hardware_type,
        'storage_system' => @storage_system
      }
      expect { klass.get_available_storage_system($client_300, query_options) }.to_not raise_error
    end
  end

  describe '#self.get_available_storage_systems' do
    it 'retrieves available storage systems without errors' do
      query_options = {
        'enclosure_group' => @enclosure_group,
        'server_hardware_type' => @server_hardware_type
      }
      expect { klass.get_available_storage_systems($client_300, query_options) }.to_not raise_error
    end
  end

  describe '#self.get_available_targets' do
    it 'retrieves available targets without errors' do
      expect { klass.get_available_targets($client_300) }.to_not raise_error
    end
  end

  describe '#self.get_profile_ports' do
    it 'retrieves profile ports without errors' do
      query_options = {
        'enclosure_group' => @enclosure_group,
        'server_hardware_type' => @server_hardware_type
      }
      expect { klass.get_profile_ports($client_300, query_options) }.to_not raise_error
    end
  end

  describe '#get_messages' do
    it 'shows messages' do
      expect { @item.get_messages }.to_not raise_error
    end
  end

  describe '#get_transformation' do
    it 'transforms an existing profile' do
      expect { @item.get_transformation('server_hardware_type' => @server_hardware_type, 'enclosure_group' => @enclosure_group) }
        .to_not raise_error
    end
  end

  describe '#get_compliance_preview' do
    it 'shows compliance preview' do
      expect { @item3.get_compliance_preview }.to_not raise_error
    end
  end

  describe '#update_from_template' do
    it 'makes the Server Profile compliant with the template' do
      expect { @item3.update_from_template }.to_not raise_error
    end
  end

  describe '#get_available_networks' do
    it 'Gets available networks' do
      item = klass.find_by($client_300, name: SERVER_PROFILE_NAME).first
      expect { item.get_available_networks }.not_to raise_error
    end
  end
end
