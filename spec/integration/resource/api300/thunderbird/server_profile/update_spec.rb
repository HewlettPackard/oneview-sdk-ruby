require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::ServerProfile
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  before :all do
    @item = klass.new($client_300, name: SERVER_PROFILE_NAME)
    @item.retrieve!
    @enclosure_group = OneviewSDK::API300::Thunderbird::EnclosureGroup.find_by($client_300, {}).first
    @server_hardware_type = OneviewSDK::API300::Thunderbird::ServerHardwareType.find_by($client_300, {}).first
    @storage_system = OneviewSDK::API300::Thunderbird::StorageSystem.find_by($client_300, {}).first
    @item3 = klass.new($client_300, name: SERVER_PROFILE2_NAME)
    @item3.retrieve!
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

  describe '#get_sas_logical_jbods' do
    it 'returns all SAS Logical JBODs' do
      expect { klass.get_sas_logical_jbods($client_300) }.not_to raise_error
    end
  end

  describe '#get_sas_logical_jbod_attachments' do
    it 'retrieves all attachments' do
      expect { klass.get_sas_logical_jbod_attachments($client_300) }.not_to raise_error
    end
  end
end
