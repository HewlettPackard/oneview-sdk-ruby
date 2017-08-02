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

RSpec.shared_examples 'UplinkSetCreateExample' do |context_name|
  include_context context_name

  let(:uplink_data) do
    {
      nativeNetworkUri: nil,
      reachability: 'Reachable',
      manualLoginRedistributionState: 'NotSupported',
      connectionMode: 'Auto',
      lacpTimer: 'Short',
      networkType: 'Ethernet',
      ethernetNetworkType: 'Tagged',
      description: nil,
      name: UPLINK_SET4_NAME
    }
  end

  let(:uplink_data2) do
    {
      nativeNetworkUri: nil,
      reachability: 'Reachable',
      manualLoginRedistributionState: 'Supported',
      connectionMode: 'Auto',
      lacpTimer: 'Short',
      networkType: 'FibreChannel',
      description: nil,
      name: UPLINK_SET5_NAME
    }
  end

  let(:log_int) do
    namespace = described_class.to_s[0, described_class.to_s.rindex('::')]
    Object.const_get("#{namespace}::LogicalInterconnect").find_by(current_client, name: li_name).first
  end

  describe '#create' do
    it 'can create the uplink and attach to a Logical Interconnect' do
      item = described_class.new(current_client, uplink_data)
      item.set_logical_interconnect(log_int)
      expect { item.create }.not_to raise_error
      expect(item[:uri]).to be
      expect(item.retrieve!).to eq(true)
    end

    it 'can create the uplink - fc network type' do
      item = described_class.new(current_client, uplink_data2)
      item.set_logical_interconnect(log_int)
      expect { item.create }.not_to raise_error
      expect(item[:uri]).to be
      expect(item.retrieve!).to eq(true)
    end
  end

  describe '#get_unassigned_ports' do
    it 'should return a hash with the unassigned uplink set ports' do
      uplink = described_class.new(current_client, name: UPLINK_SET4_NAME)
      expect(uplink.retrieve!).to eq(true)
      ports = uplink.get_unassigned_ports
      expect(ports).not_to be_empty
    end
  end
end
