require 'spec_helper'

klass = OneviewSDK::API300::C7000::ServerHardware
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  before(:all) do
    options = {
      hostname: $secrets['server_hardware_ip'],
      username: $secrets['server_hardware_username'],
      password: $secrets['server_hardware_password'],
      name: 'test',
      licensingIntent: 'OneView'
    }

    @item = OneviewSDK::API300::C7000::ServerHardware.new($client_300, options)
  end

  describe '#add' do
    it 'can create resources' do
      expect { @item.add }.to_not raise_error
    end
  end

  describe '#get_bios' do
    it 'Get list of bios\UEFI values' do
      expect { @item.get_bios }.not_to raise_error
    end
  end

  describe '#get_ilo_sso_url' do
    it 'Get a url to the iLO web interface' do
      expect { @item.get_ilo_sso_url }.not_to raise_error
    end
  end

  describe '#get_java_remote_sso_url' do
    it 'Single Sign-On session for the Java Applet console' do
      expect { @item.get_java_remote_sso_url }.not_to raise_error
    end
  end

  describe '#get_remote_console_url' do
    it 'Get a url to the iLO web interface' do
      expect { @item.get_remote_console_url }.not_to raise_error
    end
  end

  describe '#environmental_configuration' do
    it 'Gets the script' do
      expect { @item.environmental_configuration }.not_to raise_error
    end
  end

  describe '#utilization' do
    it 'Gets utilization data' do
      expect { @item.utilization }.not_to raise_error
    end
  end

  describe '#get firmware by id' do
    it 'Gets the Server Hardware firmware without uri' do
      item = OneviewSDK::API300::C7000::ServerHardware.new($client_300)
      expect { item.get_firmware_by_id }.to raise_error
    end

    it 'Gets the Server Hardware firmware' do
      response = nil
      expect { response = @item.get_firmware_by_id }.not_to raise_error
      expect(response['uri']).to eq(@item[:serverFirmwareInventoryUri])
      expect(response['category']).to eq(@item[:category])
      expect(response['serverName']).to eq($secrets['server_hardware_ip'])
      expect(response['serverModel']).to eq(@item[:model])
    end
  end

  describe '#get firmwares across all servers' do
    it 'Gets a list the firmware inventory without filter' do
      response = nil
      expect { response = @item.get_firmwares }.not_to raise_error
      expect(response.size).to be > 0
    end

    it 'Gets a list the firmware inventory by component name and like operator' do
      filters = [
        { name: 'components.componentName', operation: 'like', value: 'i%' }
      ]

      response = nil
      expect { response = @item.get_firmwares(filters) }.not_to raise_error
      expect(response.size).to be > 0
    end

    it 'Gets a list the firmware inventory by component name and matches operator' do
      filters = [
        { name: 'components.componentName', operation: 'matches', value: 'i%' }
      ]

      response = nil
      expect { response = @item.get_firmwares(filters) }.not_to raise_error
      expect(response.size).to be > 0
    end

    it 'Gets a list the firmware inventory by component name and server name' do
      filters = [
        { name: 'components.componentName', operation: '=', value: 'iLO' },
        { name: 'serverName', operation: '=', value: $secrets['server_hardware_ip'] }
      ]

      response = nil
      expect { response = @item.get_firmwares(filters) }.not_to raise_error
      expect(response.size).to eq(1)
      expect(response.first['uri']).to eq(@item[:serverFirmwareInventoryUri])
      expect(response.first['category']).to eq(@item[:category])
      expect(response.first['serverName']).to eq($secrets['server_hardware_ip'])
      expect(response.first['serverModel']).to eq(@item[:model])
    end

    it 'Gets a list the firmware inventory by all filters' do
      filters = [
        { name: 'components.componentName', operation: '=', value: 'iLO' },
        { name: 'components.componentVersion', operation: 'like', value: '2.40 pass 5 Aug 13 2015' },
        { name: 'components.componentLocation', operation: '=', value: 'System Board' },
        { name: 'serverName', operation: '=', value: 'test' },
        { name: 'serverModel', operation: '=', value: 'ProLiant DL360 Gen9' }
      ]

      expect { @item.get_firmwares(filters) }.not_to raise_error
    end

    it 'Get a list with nonexistent filter' do
      filters = [
        { name: 'something', operation: '=', value: 'iLO' }
      ]

      expect { @item.get_firmwares(filters) }.to raise_error
    end
  end

end
