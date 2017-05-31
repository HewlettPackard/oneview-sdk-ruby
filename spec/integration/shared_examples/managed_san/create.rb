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

RSpec.shared_examples 'ManagedSANCreateExample' do |context_name|
  include_context context_name

  describe '#create' do
    it 'raises MethodUnavailable' do
      item = described_class.new(current_client)
      expect { item.create }.to raise_error(/The method #create is unavailable for this resource/)
    end
  end

  describe 'Import SANs' do
    it 'creates networks' do
      described_class.find_by(current_client, deviceManagerName: san_manager_ip).each do |san|

        network = if san['isExpectedFc']
                    fc_options = {
                      connectionTemplateUri: nil,
                      autoLoginRedistribution: true,
                      fabricType: 'FabricAttach',
                      name: "FC_#{san['name']}",
                      managedSanUri: san['uri']
                    }
                    fc_network_class.new(current_client, fc_options)
                  else
                    fcoe_options = {
                      connectionTemplateUri: nil,
                      vlanId: '10',
                      name: "FCoE_#{san['name']}",
                      managedSanUri: san['uri']
                    }
                    fcoe_network_class.new(current_client, fcoe_options)
                  end

        network.create!
        network.retrieve!
        expect(network['uri']).to be
        expect(network['managedSanUri']).to be
      end
    end
  end
end
