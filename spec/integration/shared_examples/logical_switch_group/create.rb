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

RSpec.shared_examples 'LogicalSwitchGroupCreateExample' do |context_name|
  include_context context_name

  let(:type) { 'Cisco Nexus 56xx' }
  subject(:item) { described_class.new(current_client, name: LOG_SWI_GROUP_NAME) }

  describe '#create' do
    it 'LSG with unrecognized interconnect' do
      expect { item.set_grouping_parameters(1, 'invalid_type') }.to raise_error(/Switch type invalid_type/)
    end

    it 'LSG with two switches' do
      item.set_grouping_parameters(2, type)
      expect { item.create }.to_not raise_error
    end
  end

  describe '#retrieve!' do
    it 'retrieves the objects' do
      item = described_class.new(current_client, name: LOG_SWI_GROUP_NAME)
      item.retrieve!
      expect(item['uri']).to be
    end

    it 'retrieves all the objects' do
      list = described_class.find_by(current_client, {})
      expect(list).not_to be_empty
    end
  end
end
