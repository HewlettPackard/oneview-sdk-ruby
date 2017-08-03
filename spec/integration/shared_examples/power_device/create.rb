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

RSpec.shared_examples 'PowerDeviceCreateExample' do |context_name|
  include_context context_name

  describe '#add' do
    it 'can add a power device with default values' do
      item = described_class.new(current_client, name: POW_DEVICE1_NAME, ratedCapacity: 500)
      item.add
      expect(item['uri']).not_to be_empty

      item = described_class.new(current_client, uri: item['uri'])
      expect(item.retrieve!).to eq(true)
      expect(item['name']).to eq(POW_DEVICE1_NAME)
      expect(item['ratedCapacity']).to eq(500)
    end
  end

  describe '#discover [EXPECTED TO FAIL IF SCHEMATIC HAS NO IPDU]' do
    it 'can discover an HP iPDU' do
      # importing the certificate for can access remote server
      client_certificate = resource_class_of('ClientCertificate').new(current_client, aliasName: current_secrets['hp_ipdu_ip'])
      unless client_certificate.retrieve!
        web_certificate = resource_class_of('WebServerCertificate').get_certificate(current_client, current_secrets['hp_ipdu_ip'])
        client_certificate['base64SSLCertData'] = web_certificate['base64Data']
        client_certificate['aliasName'] = current_secrets['hp_ipdu_ip']
        expect { client_certificate.import }.not_to raise_error
      end

      options = {
        username: current_secrets['hp_ipdu_username'],
        password: current_secrets['hp_ipdu_password'],
        hostname: current_secrets['hp_ipdu_ip']
      }

      ipdu = described_class.discover(current_client, options)
      expect(ipdu['uri']).not_to be_empty
      expect(ipdu.retrieve!).to eq(true)
    end
  end

  describe '::get_ipdu_devices [EXPECTED TO FAIL IF SCHEMATIC HAS NO IPDU]' do
    it 'should return ipdu devices' do
      devices = described_class.get_ipdu_devices(current_client, current_secrets['hp_ipdu_ip'])
      expect(devices).not_to be_empty
    end
  end

  describe '#utilization' do
    it 'Gets utilization data' do
      item = described_class.find_by(current_client, {}).first
      utilization = []
      expect { utilization = item.utilization }.not_to raise_error
      expect(utilization).not_to be_empty
    end
  end
end
