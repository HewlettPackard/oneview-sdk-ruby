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

RSpec.shared_examples 'LogicalDownlinkCreateExample' do |context_name, execute_without_ethernet|
  include_context context_name

  describe '#create' do
    it 'raises MethodUnavailable' do
      item = described_class.new(current_client)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '#find_by' do
    it 'returns all logical downlinks in the appliance' do
      expect { described_class.find_by(current_client, {}) }.not_to raise_error
    end
  end

  describe '#get_without_ethernet', if: execute_without_ethernet do
    it 'raises MethodUnavailable' do
      item = described_class.new(current_client)
      expect { item.get_without_ethernet }.to raise_error(/The method #get_without_ethernet is unavailable for this resource/)
    end
  end

  describe '#self.get_without_ethernet', if: execute_without_ethernet do
    it 'raises MethodUnavailable' do
      expect { described_class.get_without_ethernet }.to raise_error(/The method #self.get_without_ethernet is unavailable for this resource/)
    end
  end
end
