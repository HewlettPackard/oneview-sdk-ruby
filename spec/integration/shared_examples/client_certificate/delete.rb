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

RSpec.shared_examples 'ClientCertificateDeleteExample' do |context_name|
  include_context context_name

  let(:item) { described_class.new(current_client, aliasName: current_secrets['storage_system1_ip']) }

  describe '#delete' do
    it 'should raise MethodUnavailable error' do
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#remove' do
    it 'should remove the certificate' do
      expect(item.retrieve!).to eq(true)
      expect(item.remove).to eq(true)
      expect(item.retrieve!).to eq(false)
    end
  end

  describe '::remove' do
    it 'should remove a list of certificates' do
      certificate = described_class.new(current_client, aliasName: current_secrets['storage_system2_ip'])
      expect(certificate.retrieve!).to eq(true)

      alias_names = [current_secrets['storage_system2_ip']]
      expect { described_class.remove(current_client, alias_names) }.not_to raise_error
      expect(certificate.retrieve!).to eq(false)
    end
  end
end
