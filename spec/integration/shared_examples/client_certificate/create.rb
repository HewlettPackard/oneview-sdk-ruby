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

RSpec.shared_examples 'ClientCertificateCreateExample' do |context_name|
  include_context context_name

  let(:item) { described_class.new(current_client, aliasName: current_secrets['storage_system1_ip']) }

  describe '#get_all' do
    # this example tests the ::find_with_pagination method
    it 'should get all certificates' do
      expect(described_class.get_all(current_client)).not_to be_empty
    end
  end

  describe '#create' do
    it 'should raise MethodUnavailable error' do
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#import' do
    it 'should import the given SSL certificate' do
      expect(item.retrieve!).to eq(false)
      web_certificate = resource_class_of('WebServerCertificate').get_certificate(current_client, current_secrets['storage_system1_ip'])
      item['base64SSLCertData'] = web_certificate['base64Data']
      item['aliasName'] = current_secrets['storage_system1_ip']
      expect { item.import }.not_to raise_error
      expect(item.retrieve!).to eq(true)
    end
  end

  describe '::import' do
    it 'should import the given list of SSL certificates' do
      certificate = described_class.new(current_client, aliasName: current_secrets['storage_system2_ip'])
      expect(certificate.retrieve!).to eq(false)

      web_certificate = resource_class_of('WebServerCertificate').get_certificate(current_client, current_secrets['storage_system2_ip'])
      certificate['base64SSLCertData'] = web_certificate['base64Data']
      certificate['aliasName'] = current_secrets['storage_system2_ip']

      expect { described_class.import(current_client, [certificate]) }.not_to raise_error
      expect(certificate.retrieve!).to eq(true)
    end
  end

  describe '#refresh' do
    it 'should update the current object using the data that exists on OneView' do
      expect { item.refresh }.not_to raise_error
      expect(item['base64SSLCertData']).to be
      expect(item['aliasName']).to eq(current_secrets['storage_system1_ip'])
    end
  end

  describe '#validate' do
    it 'should validate the certificate' do
      expect(item.retrieve!).to eq(true)
      expect { item.validate }.not_to raise_error
      expect(item['status']).to eq('Valid')
    end
  end
end
