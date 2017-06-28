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

RSpec.shared_examples 'ClientCertificateUpdateExample' do |context_name|
  include_context context_name

  describe '#update' do
    it 'should update the given certificate' do
      item = described_class.new(current_client, aliasName: current_secrets['storage_system1_ip'])
      expect(item.retrieve!).to eq(true)
      expect { item.update }.not_to raise_error
    end
  end

  describe '::replace' do
    it 'should replace the given list of SSL certificates' do
      certificate_1 = described_class.new(current_client, aliasName: current_secrets['storage_system1_ip'])
      expect(certificate_1.retrieve!).to eq(true)
      certificate_2 = described_class.new(current_client, aliasName: current_secrets['storage_system2_ip'])
      expect(certificate_2.retrieve!).to eq(true)

      result = []
      expect { result = described_class.replace(current_client, [certificate_1, certificate_2]) }.not_to raise_error
      expect(result.size).to eq(2)
      expect(result[0]['aliasName']).to eq(certificate_1['aliasName'])
      expect(result[1]['aliasName']).to eq(certificate_2['aliasName'])
    end
  end
end
