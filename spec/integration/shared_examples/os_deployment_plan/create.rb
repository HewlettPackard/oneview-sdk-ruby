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

RSpec.shared_examples 'OSDeploymentPlanCreateExample' do |context_name|
  include_context context_name

  describe '#create' do
    it 'should throw method unavailable exception' do
      item = described_class.new(current_client)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe '::get_all' do
    it 'should get all OS Deployment Plans' do
      items = described_class.get_all(current_client)
      expect(items).not_to be_empty
      expect(items.first.class).to eq(described_class)
    end
  end

  describe '::find_by' do
    it 'should get specific OS Deployment Plan' do
      item = described_class.get_all(current_client).first
      items_searched = described_class.find_by(current_client, name: item['name'])
      expect(items_searched.size).to eq(1)
      expect(items_searched.first['uri']).to eq(item['uri'])
    end

    context 'when there are not items for the paramater passed' do
      it 'should return an empty list' do
        items_searched = described_class.find_by(current_client, name: 'some wrong name')
        expect(items_searched).to be_empty
      end
    end
  end

  describe '#retrieve!' do
    it 'should get specific OS Deployment Plan by URI' do
      item = described_class.get_all(current_client).first
      item_retrieved = described_class.new(current_client, uri: item['uri'])
      expect(item_retrieved.retrieve!).to eq(true)
      expect(item_retrieved['name']).to eq(item['name'])
    end
  end
end
