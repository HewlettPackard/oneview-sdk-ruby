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

RSpec.shared_examples 'FCoENetworkCreateExample' do |context_name|
  include_context context_name

  let(:file_path) { 'spec/support/fixtures/integration/fcoe_network.json' }

  describe '#create' do
    it 'can create resources' do
      item = described_class.from_file(current_client, file_path)
      item.create
      expect(item[:name]).to eq(FCOE_NET_NAME)
      expect(item[:connectionTemplateUri]).not_to eq(nil)
      expect(item[:vlanId]).to eq(300)
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = described_class.new(current_client, name: FCOE_NET_NAME)
      item.retrieve!
      expect(item[:name]).to eq(FCOE_NET_NAME)
      expect(item[:connectionTemplateUri]).not_to eq(nil)
      expect(item[:vlanId]).to eq(300)
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = described_class.find_by(current_client, {}).map { |item| item[:name] }
      expect(names).to include(FCOE_NET_NAME)
    end

    it 'finds networks by multiple attributes' do
      attrs = { name: FCOE_NET_NAME, vlanId: 300 }
      names = described_class.find_by(current_client, attrs).map { |item| item[:name] }
      expect(names).to include(FCOE_NET_NAME)
    end
  end
end
