# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.


RSpec.describe OneviewSDK::API600::C7000::ServerCertificate do
  include_context 'shared context'

  let(:item) { described_class.new(@client_600, aliasName: 'hostname-Test') }
  let(:header) { { 'requestername' => 'DEFAULT' } }

  describe '#import' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new(base64Data: 'some certificate')
      expected_uri = described_class::BASE_URI
      expected_options = {
        'requestername' => 'DEFAULT',
        'body' => {
          'type' => 'CertificateInfoV2',
          'uri' => '/rest/certificates/servers/hostname-Test'
        }
      }
      expected_api_version = @client_600.api_version
      expect(item).to receive(:ensure_client)
      expect(@client_600).to receive(:rest_post).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)
      item.import
      expect(item['base64Data']).to eq('some certificate')
    end
  end

  describe '#update' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new
      expected_uri = "#{described_class::BASE_URI}/hostname-Test"
      expected_options = {
        'requestername' => 'DEFAULT',
        'body' => {
          'aliasName' => 'hostname-Test',
          'base64Data' => 'some certificate',
          'type' => 'CertificateInfoV2',
          'uri' => '/rest/certificates/servers/hostname-Test'
        }
      }
      expected_api_version = @client_600.api_version
      expect(item).to receive(:ensure_client).and_return(true)
      expect(item).to receive(:ensure_uri).and_return(true)
      expect(@client_600).to receive(:rest_put).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)
      item.update({ base64Data: 'some certificate' }, header)
      expect(item['base64Data']).to eq('some certificate')
    end
  end

  describe '#remove' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new
      expected_uri = "#{described_class::BASE_URI}/hostname-Test"
      expected_options = { 'requestername' => 'DEFAULT' }
      expected_api_version = @client_600.api_version
      expect(@client_600).to receive(:rest_delete).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)
      expect(item.remove).to eq(true)
    end
  end
end
