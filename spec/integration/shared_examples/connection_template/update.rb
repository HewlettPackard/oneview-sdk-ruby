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

RSpec.shared_examples 'ConnectionTemplateUpdateExample' do |context_name|
  include_context context_name

  describe '#get_default' do
    it 'builds connection template' do
      item = described_class.get_default(current_client)
      expect(item).to be_a described_class
    end
  end

  describe '#update' do
    it 'change bandwidth' do
      item = described_class.find_by(current_client, {}).first
      old_maximum = item['bandwidth']['maximumBandwidth']
      old_typical = item['bandwidth']['typicalBandwidth']
      item['bandwidth']['maximumBandwidth'] = old_maximum - 100
      item['bandwidth']['typicalBandwidth'] = old_typical - 100
      expect { item.update }.not_to raise_error
      expect(item['bandwidth']['maximumBandwidth']).to eq(old_maximum - 100)
      expect(item['bandwidth']['typicalBandwidth']).to eq(old_typical - 100)
      item.retrieve!
      item['bandwidth']['maximumBandwidth'] = old_maximum
      item['bandwidth']['typicalBandwidth'] = old_typical
      expect { item.update }.not_to raise_error
      expect(item['bandwidth']['maximumBandwidth']).to eq(old_maximum)
      expect(item['bandwidth']['typicalBandwidth']).to eq(old_typical)
    end
  end
end
