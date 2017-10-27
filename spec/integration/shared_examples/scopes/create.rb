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

RSpec.shared_examples 'ScopeCreateExample' do |context_name|
  include_context context_name
  let(:resource_attributes) do
    {
      name: 'Scope 1',
      description: 'Sample Scope description'
    }
  end

  describe '#create' do
    it 'should create scope' do
      item = described_class.new(current_client, resource_attributes)

      expect { item.create }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      expect(item['uri']).to be
      expect(item['type']).to eq(type)
      expect(item['name']).to eq('Scope 1')
      expect(item['description']).to eq('Sample Scope description')

      scope = described_class.new(current_client, name: 'Scope 2')
      expect { scope.create }.to_not raise_error
    end
  end

  describe '#create!' do
    it 'should retrieve, delete and create the resource' do
      item = described_class.new(current_client, resource_attributes)
      expect { item.create! }.not_to raise_error
      expect(item.retrieve!).to eq(true)
      list = described_class.find_by(current_client, resource_attributes)
      expect(list.size).to eq(1)
    end
  end
end
