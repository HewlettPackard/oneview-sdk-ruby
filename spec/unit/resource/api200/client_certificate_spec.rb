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

RSpec.describe OneviewSDK::ClientCertificate do
  include_context 'shared context'

  let(:item) { described_class.new(@client_200, aliasName: 'hostname-Test') }

  describe '#delete' do
    it 'should raise MethodUnavailable error' do
      expect { item.delete }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#create' do
    it 'should raise MethodUnavailable error' do
      expect { item.create }.to raise_error(OneviewSDK::MethodUnavailable)
    end
  end

  describe '#import' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new(base64Data: 'some certificate')
      expected_uri = described_class::BASE_URI
      expected_options = {
        'requestername' => 'DEFAULT',
        'body' => { 'aliasName' => 'hostname-Test', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test' }
      }
      expected_api_version = @client_200.api_version
      expect(item).to receive(:ensure_client)
      expect(@client_200).to receive(:rest_post).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)
      item.import
      expect(item['base64Data']).to eq('some certificate')
    end

    context 'when default header options are overrided' do
      it 'should call the api correctly' do
        fake_response = FakeResponse.new
        expected_uri = described_class::BASE_URI
        expected_options = {
          'requestername' => 'AUTHN',
          'body' => { 'aliasName' => 'hostname-Test', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test' }
        }
        expected_api_version = @client_200.api_version
        expect(item).to receive(:ensure_client)
        expect(@client_200).to receive(:rest_post).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)
        item.import('requestername' => 'AUTHN')
      end
    end
  end

  describe '::import' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new([{ base64Data: 'some certificate 1' }, { base64Data: 'some certificate 2' }])
      expected_uri = described_class::BASE_URI + '?multiResource=true'
      expected_options = {
        'requestername' => 'DEFAULT',
        'body' => [
          { 'aliasName' => 'hostname-Test_1', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test_1' },
          { 'aliasName' => 'hostname-Test_2', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test_2' }
        ]
      }
      item_1 = described_class.new(@client_200, aliasName: 'hostname-Test_1')
      item_2 = described_class.new(@client_200, aliasName: 'hostname-Test_2')
      expect(@client_200).to receive(:rest_post).with(expected_uri, expected_options).and_return(fake_response)
      result = described_class.import(@client_200, [item_1, item_2])
      expect(result.class).to be(Array)
      expect(result[0]['base64Data']).to eq('some certificate 1')
      expect(result[1]['base64Data']).to eq('some certificate 2')
    end

    context 'when do not pass certificates list' do
      it 'should raise argument error' do
        expect { described_class.import(@client_200, []) }.to raise_error(ArgumentError, /the certificates list should be valid/)
      end

      it 'should raise argument error' do
        expect { described_class.import(@client_200, nil) }.to raise_error(ArgumentError, /the certificates list should be valid/)
      end
    end

    context 'when default header options are overrided' do
      it 'should call the api correctly' do
        fake_response = FakeResponse.new
        expected_uri = described_class::BASE_URI + '?multiResource=true'
        expected_options = {
          'requestername' => 'AUTHN',
          'body' => [
            { 'aliasName' => 'hostname-Test_1', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test_1' },
            { 'aliasName' => 'hostname-Test_2', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test_2' }
          ]
        }
        item_1 = described_class.new(@client_200, aliasName: 'hostname-Test_1')
        item_2 = described_class.new(@client_200, aliasName: 'hostname-Test_2')
        expect(@client_200).to receive(:rest_post).with(expected_uri, expected_options).and_return(fake_response)
        described_class.import(@client_200, [item_1, item_2], 'requestername' => 'AUTHN')
      end
    end
  end

  describe '#refresh' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new(base64Data: 'some certificate')
      expected_uri = "#{described_class::BASE_URI}/hostname-Test"
      expected_options = { 'requestername' => 'DEFAULT' }
      expected_api_version = @client_200.api_version
      expect(item).to receive(:ensure_client)
      expect(@client_200).to receive(:rest_api).with(:get, expected_uri, expected_options, expected_api_version).and_return(fake_response)
      item.refresh
      expect(item['base64Data']).to eq('some certificate')
    end

    context 'when default header options are overrided' do
      it 'should call the api correctly' do
        fake_response = FakeResponse.new
        expected_uri = "#{described_class::BASE_URI}/hostname-Test"
        expected_options = { 'requestername' => 'AUTHN' }
        expected_api_version = @client_200.api_version
        expect(item).to receive(:ensure_client)
        expect(@client_200).to receive(:rest_api).with(:get, expected_uri, expected_options, expected_api_version).and_return(fake_response)
        item.refresh('requestername' => 'AUTHN')
      end
    end
  end

  describe '#update' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new(base64Data: 'some certificate')
      expected_uri = "#{described_class::BASE_URI}/hostname-Test"
      expected_options = {
        'requestername' => 'DEFAULT',
        'body' => { 'aliasName' => 'hostname-Test', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test' }
      }
      expected_api_version = @client_200.api_version
      expect(item).to receive(:ensure_client).and_return(true)
      expect(item).to receive(:ensure_uri).and_return(true)
      expect(@client_200).to receive(:rest_put).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)
      item.update
      expect(item['base64Data']).to eq('some certificate')
    end

    context 'when default header options are overrided' do
      it 'should call the api correctly' do
        fake_response = FakeResponse.new
        expected_uri = "#{described_class::BASE_URI}/hostname-Test"
        expected_options = {
          'requestername' => 'AUTHN',
          'body' => {
            'aliasName' => 'hostname-Test',
            'type' => 'SSLCertificateDTO',
            'uri' => '/rest/certificates/hostname-Test',
            'base64Data' => 'new_data'
          }
        }
        expected_api_version = @client_200.api_version
        expect(item).to receive(:ensure_client).and_return(true)
        expect(item).to receive(:ensure_uri).and_return(true)
        expect(@client_200).to receive(:rest_put).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)
        item.update({ 'base64Data' => 'new_data' }, 'requestername' => 'AUTHN')
        expect(item['base64Data']).to eq('new_data')
      end
    end
  end

  describe '::replace' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new([{ base64Data: 'some certificate 1' }, { base64Data: 'some certificate 2' }])
      expected_uri = described_class::BASE_URI + '?multiResource=true&force=false'
      expected_options = {
        'requestername' => 'DEFAULT',
        'body' => [
          { 'aliasName' => 'hostname-Test_1', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test_1' },
          { 'aliasName' => 'hostname-Test_2', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test_2' }
        ]
      }
      item_1 = described_class.new(@client_200, aliasName: 'hostname-Test_1')
      item_2 = described_class.new(@client_200, aliasName: 'hostname-Test_2')
      expect(@client_200).to receive(:rest_put).with(expected_uri, expected_options).and_return(fake_response)
      result = described_class.replace(@client_200, [item_1, item_2])
      expect(result.class).to be(Array)
      expect(result[0]['base64Data']).to eq('some certificate 1')
      expect(result[1]['base64Data']).to eq('some certificate 2')
    end

    context 'when do not pass certificates list' do
      it 'should raise argument error' do
        expect { described_class.replace(@client_200, []) }.to raise_error(ArgumentError, /the certificates list should be valid/)
      end

      it 'should raise argument error' do
        expect { described_class.replace(@client_200, nil) }.to raise_error(ArgumentError, /the certificates list should be valid/)
      end
    end

    context 'when default header options and force param are overrided' do
      it 'should call the api correctly' do
        fake_response = FakeResponse.new
        expected_uri = described_class::BASE_URI + '?multiResource=true&force=true'
        expected_options = {
          'requestername' => 'AUTHN',
          'body' => [
            { 'aliasName' => 'hostname-Test_1', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test_1' },
            { 'aliasName' => 'hostname-Test_2', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test_2' }
          ]
        }
        item_1 = described_class.new(@client_200, aliasName: 'hostname-Test_1')
        item_2 = described_class.new(@client_200, aliasName: 'hostname-Test_2')
        expect(@client_200).to receive(:rest_put).with(expected_uri, expected_options).and_return(fake_response)
        described_class.replace(@client_200, [item_1, item_2], true, 'requestername' => 'AUTHN')
      end
    end
  end

  describe '#remove' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new
      expected_uri = "#{described_class::BASE_URI}/hostname-Test"
      expected_options = { 'requestername' => 'DEFAULT' }
      expected_api_version = @client_200.api_version
      expect(item).to receive(:ensure_client).and_return(true)
      expect(item).to receive(:ensure_uri).and_return(true)
      expect(@client_200).to receive(:rest_delete).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)
      expect(item.remove).to eq(true)
    end

    context 'when default header options are overrided' do
      it 'should call the api correctly' do
        fake_response = FakeResponse.new
        expected_uri = "#{described_class::BASE_URI}/hostname-Test"
        expected_options = { 'requestername' => 'AUTHN' }
        expected_api_version = @client_200.api_version
        expect(item).to receive(:ensure_client).and_return(true)
        expect(item).to receive(:ensure_uri).and_return(true)
        expect(@client_200).to receive(:rest_delete).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)
        expect(item.remove('requestername' => 'AUTHN')).to eq(true)
      end
    end
  end

  describe '::remove' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new
      expected_uri = described_class::BASE_URI + '?multiResource=true&force=false&filter=hostname-Test_1&filter=hostname-Test_2'
      expected_options = { 'requestername' => 'DEFAULT' }
      expect(@client_200).to receive(:rest_delete).with(expected_uri, expected_options).and_return(fake_response)
      described_class.remove(@client_200, ['hostname-Test_1', 'hostname-Test_2'])
    end

    context 'when do not pass certificates list' do
      it 'should raise argument error' do
        expect { described_class.replace(@client_200, []) }.to raise_error(ArgumentError, /the certificates list should be valid/)
      end

      it 'should raise argument error' do
        expect { described_class.replace(@client_200, nil) }.to raise_error(ArgumentError, /the certificates list should be valid/)
      end
    end

    context 'when default header options and force param are overrided' do
      it 'should call the api correctly' do
        fake_response = FakeResponse.new
        expected_uri = described_class::BASE_URI + '?multiResource=true&force=true&filter=hostname-Test_1&filter=hostname-Test_2'
        expected_options = { 'requestername' => 'AUTHN' }
        expect(@client_200).to receive(:rest_delete).with(expected_uri, expected_options).and_return(fake_response)
        described_class.remove(@client_200, ['hostname-Test_1', 'hostname-Test_2'], true, 'requestername' => 'AUTHN')
      end
    end
  end

  describe '#find_with_pagination' do
    it 'returns an empty array if no results are found' do
      fake_response = FakeResponse.new(members: [])
      expect(@client_200).to receive(:rest_api).and_return(fake_response)
      res = described_class.find_with_pagination(@client_200, 'some_uri/123')
      expect(res.size).to eq(0)
    end

    context 'when default header options are overrided' do
      it 'should call the api correctly' do
        fake_response = FakeResponse.new(members: [])
        expect(@client_200).to receive(:rest_api).with(:get, 'some_uri/123', 'requestername' => 'AUTHN').and_return(fake_response)
        res = described_class.find_with_pagination(@client_200, 'some_uri/123', 'requestername' => 'AUTHN')
        expect(res.size).to eq(0)
      end
    end

    context 'when there are many pages' do
      context "and, in the last page, body['nextPageUri'] is nil" do
        it 'should return all resources' do
          fake_response_1 = FakeResponse.new(members: [
            { name: 'Enc1', uri: "#{OneviewSDK::Enclosure::BASE_URI}/1" },
            { name: 'Enc2', uri: "#{OneviewSDK::Enclosure::BASE_URI}/2" }
          ], nextPageUri: 'page/2', uri: 'page/1')

          fake_response_2 = FakeResponse.new(members: [
            { name: 'Enc3', uri: "#{OneviewSDK::Enclosure::BASE_URI}/3" },
            { name: 'Enc4', uri: "#{OneviewSDK::Enclosure::BASE_URI}/4" }
          ], uri: 'page/2')

          expect(@client_200).to receive(:rest_api).and_return(fake_response_1)
          expect(@client_200).to receive(:rest_api).and_return(fake_response_2)
          res = described_class.find_with_pagination(@client_200, 'some_uri/123')
          expect(res.size).to eq(4)
          res.each_with_index do |r, index|
            expect(r['name']).to eq("Enc#{index + 1}")
          end
        end
      end

      context "and, in the last page, body['uri'] is equals to body['nextPageUri']" do
        it 'should returns all resources' do
          fake_response_1 = FakeResponse.new(members: [
            { name: 'Enc1', uri: "#{OneviewSDK::Enclosure::BASE_URI}/1" },
            { name: 'Enc2', uri: "#{OneviewSDK::Enclosure::BASE_URI}/2" }
          ], nextPageUri: 'page/2', uri: 'page/1')

          fake_response_2 = FakeResponse.new(members: [
            { name: 'Enc3', uri: "#{OneviewSDK::Enclosure::BASE_URI}/3" },
            { name: 'Enc4', uri: "#{OneviewSDK::Enclosure::BASE_URI}/4" }
          ], nextPageUri: 'page/2', uri: 'page/2')

          expect(@client_200).to receive(:rest_api).and_return(fake_response_1)
          expect(@client_200).to receive(:rest_api).and_return(fake_response_2)
          res = described_class.find_with_pagination(@client_200, 'some_uri/123')
          expect(res.size).to eq(4)
          res.each_with_index do |r, index|
            expect(r['name']).to eq("Enc#{index + 1}")
          end
        end
      end
    end
  end

  describe '#validate' do
    it 'should call the api correctly' do
      fake_response = FakeResponse.new(status: 'Valid')
      expected_uri = "#{described_class::BASE_URI}/validator"
      expected_options = {
        'requestername' => 'DEFAULT',
        'body' => { 'aliasName' => 'hostname-Test', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test' }
      }
      expected_api_version = @client_200.api_version
      expect(item).to receive(:ensure_client).and_return(true)
      expect(item).to receive(:ensure_uri).and_return(true)
      expect(@client_200).to receive(:rest_post).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)
      item.validate
      expect(item['status']).to eq('Valid')
    end

    context 'when default header options are overrided' do
      it 'should call the api correctly' do
        fake_response = FakeResponse.new(status: 'Valid')
        expected_uri = "#{described_class::BASE_URI}/validator"
        expected_options = {
          'requestername' => 'AUTHN',
          'body' => { 'aliasName' => 'hostname-Test', 'type' => 'SSLCertificateDTO', 'uri' => '/rest/certificates/hostname-Test' }
        }
        expected_api_version = @client_200.api_version
        expect(item).to receive(:ensure_client).and_return(true)
        expect(item).to receive(:ensure_uri).and_return(true)
        expect(@client_200).to receive(:rest_post).with(expected_uri, expected_options, expected_api_version).and_return(fake_response)
        item.validate('requestername' => 'AUTHN')
        expect(item['status']).to eq('Valid')
      end
    end
  end
end
