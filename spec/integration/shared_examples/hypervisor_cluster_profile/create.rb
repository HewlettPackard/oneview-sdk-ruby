# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
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

RSpec.shared_examples 'HypervisorClusterProfileCreateExample' do |context_name|
  include_context context_name

  let(:file_path) { 'spec/support/fixtures/integration/hypervisor_cluster_profile.json' }

  describe '#create' do
    it 'can create resources' do
      item = described_class.from_file(current_client, file_path)

      item.create
      expect(item[:name]).to eq(HYP_CLUSTER_PROF)
      expect(item[:hypervisorType]).to eq(Vmware)
      expect(item[:deploymentPlanUri]).not_to eq(nil)
      expect(item[:type]).to eq('HypervisorClusterProfileV3')
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = described_class.new(current_client, name: HYP_CLUSTER_PROF)
      item.retrieve!
      expect(item[:name]).to eq(HYP_CLUSTER_PROF)
      expect(item[:hypervisorType]).to eq(Vmware)
      expect(item[:deploymentPlanUri]).not_to eq(nil)
      expect(item[:type]).to eq('HypervisorClusterProfileV3')
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = described_class.find_by(current_client, {}).map { |item| item[:name] }
      expect(names).to include(HYP_CLUSTER_PROF)
    end
  end

  describe '#compliance_preview' do
    it 'Gets the compliance preview' do
      item = described_class.get_all(current_client).first
      item.compliance_preview
      expect { item.compliance_preview }.not_to raise_error
    end
  end
end
