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

RSpec.shared_examples 'WebServerCertificateUpdateExample' do |context_name|
  include_context context_name

  describe '#update' do
    it 'should raise MethodUnavailable error' do
      item = described_class.new(current_client)
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#import' do
    xit "should import the certificate [FAILING: it's necessary to submit the CSR to the CA, but we have not CA]" do
      item = described_class.new(current_client)
      expect(item.retrieve!).to eq(true)
      item2 = described_class.new(current_client, base64Data: item['base64Data'], type: 'CertificateDataV2')
      expect { item2.import }.not_to raise_error
    end
  end
end
