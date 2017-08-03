# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::PowerDevice do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::PowerDevice
  end

  before :each do
    @item = OneviewSDK::API300::C7000::PowerDevice.new(@client_300, uri: '/rest/fake')
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      expect(@item['deviceType']).to eq('BranchCircuit')
      expect(@item['phaseType']).to eq('Unknown')
      expect(@item['powerConnections']).to eq([])
    end
  end

  describe '#add_connection' do
    it 'add one connection' do
      resource = Hash.new(uri: '/rest/enclosure/fake-encl1')
      @item.add_connection(resource, 1)
      connection = @item['powerConnections'].first
      expect(connection['connectionUri']).to eq(resource[:uri])
      expect(connection['deviceConnection']).to eq(1)
    end

    it 'add multiple connections' do
      resource = Hash.new(uri: '/rest/enclosure/fake-encl1')
      @item.add_connection(resource, 1)
      @item.add_connection(resource, 2)
      connection1 = @item['powerConnections'].first
      connection2 = @item['powerConnections'].last
      expect(connection1['connectionUri']).to eq(resource[:uri])
      expect(connection1['deviceConnection']).to eq(1)
      expect(connection2['connectionUri']).to eq(resource[:uri])
      expect(connection2['deviceConnection']).to eq(2)
    end
  end

  describe '#remove_connection' do
    it 'remove connection' do
      resource = Hash.new(uri: '/rest/enclosure/fake-encl1')
      @item.add_connection(resource, 1)
      @item.remove_connection(resource, 1)
      expect(@item['powerConnections'].size).to eq(0)
    end

    it 'remove connection and verify others' do
      resource = Hash.new(uri: '/rest/enclosure/fake-encl1')
      @item.add_connection(resource, 1)
      @item.add_connection(resource, 2)
      @item.add_connection(resource, 3)
      @item.remove_connection(resource, 2)
      expect(@item['powerConnections'].size).to eq(2)
      connection1 = @item['powerConnections'].first
      connection2 = @item['powerConnections'].last
      expect(connection1['connectionUri']).to eq(resource[:uri])
      expect(connection1['deviceConnection']).to eq(1)
      expect(connection2['connectionUri']).to eq(resource[:uri])
      expect(connection2['deviceConnection']).to eq(3)
    end
  end

  describe '#add' do
    it 'Should support add' do
      power_device = OneviewSDK::API300::C7000::PowerDevice.new(@client_300, name: 'power_device', ratedCapacity: 500)
      expected_request_body = {
        'name' => 'power_device',
        'ratedCapacity' => 500,
        'deviceType' => 'BranchCircuit',
        'phaseType' => 'Unknown',
        'powerConnections' => []
      }
      expect(@client_300).to receive(:rest_post).with('/rest/power-devices', { 'body' => expected_request_body }, 300)
        .and_return(FakeResponse.new({}))
      power_device.add
    end
  end

  describe '#remove' do
    it 'Should support remove' do
      power_device = OneviewSDK::API300::C7000::PowerDevice.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_delete).with('/rest/fake', {}, 300).and_return(FakeResponse.new({}))
      power_device.remove
    end
  end

  describe '#create' do
    it 'Should raise error if used' do
      power_device = OneviewSDK::API300::C7000::PowerDevice.new(@client_300)
      expect { power_device.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#delete' do
    it 'Should raise error if used' do
      power_device = OneviewSDK::API300::C7000::PowerDevice.new(@client_300)
      expect { power_device.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end


  describe '#discover' do
    it 'Correct request' do
      options = {
        username: 'user',
        password: 'pass',
        hostname: '/rest/fake'
      }
      expect(@client_300).to receive(:rest_post).with('/rest/power-devices/discover', 'body' => options)
        .and_return(FakeResponse.new({}))
      expect { OneviewSDK::API300::C7000::PowerDevice.discover(@client_300, options) }.not_to raise_error
    end
  end

  describe '#get_power_state' do
    it 'powerState' do
      expect(@client_300).to receive(:rest_get).with('/rest/fake/powerState')
        .and_return(FakeResponse.new({}))
      expect { @item.get_power_state }.not_to raise_error
    end
  end

  describe '#set_power_state' do
    it 'On|Off state given' do
      expect(@client_300).to receive(:rest_put).with('/rest/fake/powerState', 'body' => { powerState: 'On' })
        .and_return(FakeResponse.new({}))
      expect { @item.set_power_state('On') }.not_to raise_error
    end
  end

  describe '#set_refresh_state' do
    it 'Refresh without changing username and password' do
      expect(@client_300).to receive(:rest_put).with('/rest/fake/refreshState', 'body' => { refreshState: 'RefreshPending' })
        .and_return(FakeResponse.new({}))
      expect { @item.set_refresh_state(refreshState: 'RefreshPending') }.not_to raise_error
    end

    it 'Refresh providing username/password' do
      options = { refreshState: 'RefreshPending', username: 'user', password: 'pass' }
      expect(@client_300).to receive(:rest_put).with('/rest/fake/refreshState', 'body' => options)
        .and_return(FakeResponse.new({}))
      expect { @item.set_refresh_state(refreshState: 'RefreshPending', username: 'user', password: 'pass') }.not_to raise_error
    end
  end

  describe '#get_uid_state' do
    it 'uidState' do
      expect(@client_300).to receive(:rest_get).with('/rest/fake/uidState')
        .and_return(FakeResponse.new({}))
      expect { @item.get_uid_state }.not_to raise_error
    end
  end

  describe '#set_uid_state' do
    it 'On|Off state' do
      expect(@client_300).to receive(:rest_put).with('/rest/fake/uidState', 'body' => { uidState: 'On' })
        .and_return(FakeResponse.new({}))
      expect { @item.set_uid_state('On') }.not_to raise_error
    end
  end

  describe '#utilization' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::C7000::PowerDevice.new(@client_300).utilization }.to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/utilization' do
      expect(@client_300).to receive(:rest_get).with('/rest/fake/utilization', {}, @item.api_version).and_return(FakeResponse.new(key: 'val'))
      expect(@item.utilization).to eq('key' => 'val')
    end

    it 'takes query parameters' do
      expect(@client_300).to receive(:rest_get).with('/rest/fake/utilization?key=val', {}, @item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(@item.utilization(key: :val)).to eq('key' => 'val')
    end

    it 'takes an array for the :fields query parameter' do
      expect(@client_300).to receive(:rest_get).with('/rest/fake/utilization?fields=one,two,three', {}, @item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(@item.utilization(fields: %w(one two three))).to eq('key' => 'val')
    end

    it 'converts Time query parameters' do
      t = Time.now
      expect(@client_300).to receive(:rest_get).with("/rest/fake/utilization?filter=startDate=#{t.utc.iso8601(3)}", {}, @item.api_version)
        .and_return(FakeResponse.new(key: 'val'))
      expect(@item.utilization(startDate: t)).to eq('key' => 'val')
    end
  end
end
