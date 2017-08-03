# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require 'spec_helper'

RSpec.describe OneviewSDK::WebServerCertificate do
  include_context 'shared context'

  let(:item) { described_class.new(@client_200) }

  describe '#update' do
    it 'should raise MethodUnavailable error' do
      expect { item.update }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#delete' do
    it 'should raise MethodUnavailable error' do
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#create!' do
    it 'should raise MethodUnavailable error' do
      expect { item.create! }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#retrieve!' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new(base64Data: 'some certificate')
      expect(@client_200).to receive(:rest_get).with(described_class::BASE_URI).and_return(fake_response)
      expect(item.retrieve!).to eq(true)
      expect(item['base64Data']).to eq('some certificate')
    end
  end

  describe '#import' do
    it 'should call the api correctly' do
      item['base64Data'] = 'some value here'
      expected_uri = described_class::BASE_URI + '/certificaterequest'
      expected_options = { 'body' => { 'base64Data' => 'some value here' } }
      expected_api_version = 200
      fake_response = FakeResponse.new(base64Data: 'some certificate')

      expect(item).to receive(:ensure_client)
      expect(@client_200).to receive(:rest_put).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)

      item.import

      expect(item['base64Data']).to eq('some certificate')
    end
  end

  describe '#create' do
    it 'should call the api correctly' do
      item['base64Data'] = 'some value here'
      expected_uri = described_class::BASE_URI + '/certificaterequest'
      expected_options = { 'body' => { 'base64Data' => 'some value here' } }
      expected_api_version = 200
      fake_response = FakeResponse.new(base64Data: 'some certificate')

      expect(item).to receive(:ensure_client)
      expect(@client_200).to receive(:rest_post).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)

      item.create

      expect(item['base64Data']).to eq('some certificate')
    end
  end

  describe '#create_self_signed' do
    it 'should call the api correctly' do
      item['base64Data'] = 'some value here'
      expected_uri = described_class::BASE_URI
      expected_options = { 'body' => { 'base64Data' => 'some value here' } }
      expected_api_version = 200
      fake_response = FakeResponse.new(base64Data: 'some certificate')

      expect(item).to receive(:ensure_client)
      expect(@client_200).to receive(:rest_put).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)

      item.create_self_signed

      expect(item['base64Data']).to eq('some certificate')
    end
  end

  describe '::get_certificate' do
    it 'should call the api correctly' do
      expected_uri = described_class::BASE_URI + '/remote/127.0.0.1'
      expected_options = { 'requestername' => 'DEFAULT' }
      fake_response = FakeResponse.new(base64Data: 'some certificate')

      expect(@client_200).to receive(:rest_api).with(:get, expected_uri, expected_options).and_return(fake_response)

      item = described_class.get_certificate(@client_200, '127.0.0.1')

      expect(item['base64Data']).to eq('some certificate')
    end
  end
end
