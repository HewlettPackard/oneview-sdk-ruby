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

RSpec.shared_examples 'WebServerCertificateCreateExample' do |context_name|
  include_context context_name

  let(:item) { described_class.new(current_client) }

  describe '#create!' do
    it 'should raise MethodUnavailable error' do
      expect { item.create! }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#retrieve!' do
    it 'should retrieve the existing SSL certificate information' do
      expect(item.retrieve!).to eq(true)
      expect(item['alternativeName']).to include(current_client.url.delete('https://').delete('http://'))
    end
  end

  describe '#create_self_signed' do
    it 'should create a new self-signed appliance certificate' do
      expect(item.retrieve!).to eq(true)
      expect { item.create_self_signed }.not_to raise_error
    end
  end

  describe '#create' do
    it 'should create a certificate signing request' do
      expect(item.retrieve!).to eq(true)
      attributes = {
        base64Data: item['base64Data'],
        commonName: 'thetemplate.example.com',
        country: 'BR',
        locality: 'Fortaleza',
        organization: 'HPE',
        state: 'Ceara',
        type: 'CertificateDtoV2'
      }
      new_item = described_class.new(current_client, attributes)
      expect { new_item.create }.not_to raise_error
      expect(new_item['uri']).to be
    end
  end

  describe '::get_certificate' do
    it 'should retrieve the web server certificate of the specified remote appliance' do
      certificate = described_class.get_certificate(current_client, current_secrets['storage_system1_ip'])
      expect(certificate).to be
    end
  end
end
