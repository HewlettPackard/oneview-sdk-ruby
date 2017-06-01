# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

RSpec.shared_examples 'ServerHardwareUpdateExample' do |context_name, api_version|
  include_context context_name

  before(:each) do
    @item = described_class.new(current_client, hostname: hostname)
    @item.retrieve!
    @response = nil
  end

  describe '#update' do
    it 'raises MethodUnavailable' do
      expect { @item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end

  describe '#retrieve' do
    it 'retrieves a server hardware by hostname' do
      item = described_class.new(current_client, hostname: hostname)
      expect(item.retrieve!).to eq(true)
    end

    it 'retrieves a server hardware by mpHostName' do
      options = { 'mpHostInfo' => { 'mpHostName' => hostname } }
      item = described_class.new(current_client, options)
      expect(item.retrieve!).to eq(true)
    end
  end

  describe '#exists?' do
    it 'return true if a resource exists' do
      item = described_class.new(current_client, hostname: hostname)
      expect(item.exists?).to eq(true)
    end

    it 'return alse if a resource does not exist' do
      item = described_class.new(current_client, hostname: 'any')
      expect(item.exists?).to eq(false)
    end
  end

  describe '#get_bios' do
    it 'Get list of bios\UEFI values' do
      expect { @response = @item.get_bios }.not_to raise_error
      expect(@response['currentSettings']).not_to be_empty
    end
  end

  describe '#get_ilo_sso_url' do
    it 'Get a url to the iLO web interface' do
      expect { @response = @item.get_ilo_sso_url }.not_to raise_error
      expect(@response['iloSsoUrl']).to be
    end
  end

  describe '#get_java_remote_sso_url' do
    it 'Single Sign-On session for the Java Applet console' do
      expect { @response = @item.get_java_remote_sso_url }.not_to raise_error
      expect(@response['javaRemoteConsoleUrl']).to be
    end
  end

  describe '#get_remote_console_url' do
    it 'Get a url to the iLO web interface' do
      expect { @response = @item.get_remote_console_url }.not_to raise_error
      expect(@response['remoteConsoleUrl']).to be
    end
  end

  describe '#environmental_configuration' do
    it 'Gets the script' do
      expect { @response = @item.environmental_configuration }.not_to raise_error
      expect(@response['calibratedMaxPower']).to be
      expect(@response['idleMaxPower']).to be
      expect(@response['capHistorySupported']).to be
      expect(@response['height']).to be
      expect(@response['historyBufferSize']).to be
      expect(@response['historySampleIntervalSeconds']).to be
      expect(@response['licenseRequirement']).to be
      expect(@response['powerHistorySupported']).to be
      expect(@response['thermalHistorySupported']).to be
      expect(@response['uSlot']).to be
      expect(@response['utilizationHistorySupported']).to be
    end
  end

  describe '#utilization' do
    it 'Gets utilization data' do
      expect { @response = @item.utilization }.not_to raise_error
      expect(@response['metricList']).to be
    end

    it 'Gets utilization data by day' do
      expect { @response = @item.utilization(view: 'day') }.not_to raise_error
      expect(@response['metricList']).to be
    end

    it 'Gets utilization data by fields' do
      expect { @response = @item.utilization(fields: %w(AmbientTemperature)) }.not_to raise_error
      expect(@response['metricList']).to be
    end

    it 'Gets utilization data by filters' do
      t = Time.now
      expect { @response = @item.utilization(startDate: t) }.not_to raise_error
      expect(@response['metricList']).to be
    end

    it 'Gets utilization data by date' do
      t = Date.new
      expect { @response = @item.utilization(startDate: t) }.not_to raise_error
      expect(@response['metricList']).to be
    end

    it 'Gets utilization data by date as string' do
      t = Date.new
      expect { @response = @item.utilization(startDate: t.to_s) }.not_to raise_error
      expect(@response['metricList']).to be
    end

    it 'raise exception when date has invalid format' do
      t = Object.new
      expect { @response = @item.utilization(startDate: t) }.to raise_error(/Invalid time format/)
    end
  end

  describe '#get firmware by id', if: api_version >= 300 do
    it 'Gets the Server Hardware firmware without uri' do
      @item2 = described_class.new(current_client)
      expect { @item2.get_firmware_by_id }.to raise_error(/Please set uri attribute before interacting with this resource/)
    end

    it 'Gets the Server Hardware firmware' do
      expect { @response = @item.get_firmware_by_id }.not_to raise_error
      # serverFirmwareInventoryUri: This comparison will fail, due to bug in Oneview 3.10 (Backward Compatibility - this attribute is filled out)
      # expect(@response['uri']).to eq(@item['serverFirmwareInventoryUri'])
      expect(@response['category']).to eq(@item['category'])
      expect(@response['serverName']).to eq(@item['name'])
      expect(@response['serverModel']).to eq(@item['model'])
    end
  end

  describe '#get firmwares across all servers', if: api_version >= 300 do
    it 'Gets a list the firmware inventory without filter' do
      expect { @response = @item.get_firmwares }.not_to raise_error
      expect(@response.size).to be > 0
    end

    it 'Gets a list the firmware inventory by component name and like operator' do
      filters = [
        { name: 'components.componentName', operation: 'like', value: 'i%' }
      ]

      expect { @response = @item.get_firmwares(filters) }.not_to raise_error
      expect(@response.size).to be > 0
    end

    it 'Gets a list the firmware inventory by component name and matches operator' do
      filters = [
        { name: 'components.componentName', operation: 'matches', value: 'i%' }
      ]

      expect { @response = @item.get_firmwares(filters) }.not_to raise_error
      expect(@response.size).to be > 0
    end

    it 'Gets a list the firmware inventory by component name and server name' do
      filters = [
        { name: 'components.componentName', operation: '=', value: 'iLO' },
        { name: 'serverName', operation: '=', value: @item['name'] }
      ]

      expect { @response = @item.get_firmwares(filters) }.not_to raise_error
      expect(@response.size).to eq(1)
      # serverFirmwareInventoryUri: This comparison will fail, due to bug in Oneview 3.10 (Backward Compatibility - this attribute is filled out)
      # expect(@response['uri']).to eq(@item['serverFirmwareInventoryUri'])
      expect(@response.first['category']).to eq(@item['category'])
      expect(@response.first['serverName']).to eq(@item['name'])
      expect(@response.first['serverModel']).to eq(@item['model'])
    end

    it 'Gets a list the firmware inventory by all filters' do
      filters = [
        { name: 'components.componentName', operation: '=', value: 'iLO' },
        { name: 'components.componentVersion', operation: 'like', value: '2.40 pass 5 Aug 13 2015' },
        { name: 'components.componentLocation', operation: '=', value: 'System Board' },
        { name: 'serverName', operation: '=', value: @item['name'] },
        { name: 'serverModel', operation: '=', value: @item['model'] }
      ]

      expect { @item.get_firmwares(filters) }.not_to raise_error
    end

    it 'Get a list with nonexistent filter' do
      filters = [
        { name: 'something', operation: '=', value: 'iLO' }
      ]

      expect { @item.get_firmwares(filters) }.to raise_error(OneviewSDK::BadRequest)
    end
  end

  describe '#get_physical_server_hardware', if: api_version >= 500 do
    xit 'Gets the physical server hardware inventory - It is only supported for SDX servers. DCS does not yet support' do
      expect { @result = @item.get_physical_server_hardware }.not_to raise_error
    end
  end

  describe '#set_refresh_state' do
    it 'Refresh state with no additional parameters' do
      expect { @item.set_refresh_state('RefreshPending') }.not_to raise_error
    end

    it 'Refresh state with additional parameters' do
      expect { @item.set_refresh_state('RefreshPending', resfreshActions: 'ClearSyslog') }.not_to raise_error
    end
  end

  describe '#power' do
    it 'Power off server hardware' do
      expect { @item.power_off }.not_to raise_error
      @item.retrieve!
      expect(@item['powerState']).to eq('Off')
    end

    it 'Power on server hardware' do
      expect { @item.power_on }.not_to raise_error
      @item.retrieve!
      expect(@item['powerState']).to eq('On')
    end

    it 'Force power off server hardware' do
      expect { @item.power_off(true) }.not_to raise_error
      @item.retrieve!
      expect(@item['powerState']).to eq('Off')
    end
  end

  describe '#update_ilo_firmware' do
    it 'Update iLO firmware to OneView minimum supported version' do
      expect { @item.update_ilo_firmware }.not_to raise_error
    end
  end
end
