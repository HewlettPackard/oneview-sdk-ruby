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

RSpec.shared_examples 'EthernetNetworkDeleteExample' do |context_name|
  include_context context_name

  describe '#delete' do
    it 'deletes the resource' do
      item = described_class.new(current_client, name: ETH_NET_NAME)
      item.retrieve!
      expect { item.delete }.not_to raise_error
    end

    it 'deletes bulk created networks' do
      range = BULK_ETH_NET_RANGE.split('-').map(&:to_i)
      network_names = []
      range[0].upto(range[1]) { |i| network_names << "#{BULK_ETH_NET_PREFIX}_#{i}" }
      network_names.each do |name|
        network = described_class.new(current_client, name: name)
        network.retrieve!
        expect { network.delete }.not_to raise_error
      end
    end
  end
end
