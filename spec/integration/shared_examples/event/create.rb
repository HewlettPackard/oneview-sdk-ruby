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

RSpec.shared_examples 'EventCreateExample' do |context_name|
  include_context context_name

  let(:item_attributes) do
    {
      eventTypeID: 'source-test.event-id',
      description: 'This is a very simple test event',
      serviceEventSource: true,
      urgency: 'None',
      severity: 'OK',
      healthCategory: 'PROCESSOR',
      eventDetails: [
        {
          eventItemName: 'ipv4Address',
          eventItemValue: '172.16.10.81',
          isThisVarbindData: false,
          varBindOrderIndex: -1
        }
      ]
    }
  end

  describe '#create' do
    it 'can create resources' do
      item = described_class.new(current_client, item_attributes)
      expect { item.create }.not_to raise_error
      expect(item['uri']).to be
      expect(item.retrieve!).to eq(true)
    end
  end

  describe '#update' do
    it 'should raise MethodUnavailable' do
      item = described_class.new(current_client)
      expect { item.update }.to raise_error(/The method #update is unavailable for this resource/)
    end
  end

  describe '#delete' do
    it 'should raise MethodUnavailable' do
      item = described_class.new(current_client)
      expect { item.delete }.to raise_error(/The method #delete is unavailable for this resource/)
    end
  end
end
