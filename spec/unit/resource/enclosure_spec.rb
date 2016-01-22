require 'spec_helper'

RSpec.describe OneviewSDK::Enclosure do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 1.2' do
      it 'sets the defaults correctly' do
        enclosure = OneviewSDK::Enclosure.new(@client_120)
        expect(enclosure[:type]).to eq('EnclosureV2')
      end
    end

    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        enclosure = OneviewSDK::Enclosure.new(@client)
        expect(enclosure[:type]).to eq('EnclosureV200')
      end
    end
  end

  describe '#create' do
    context 'with valid data' do
      before :each do
        allow_any_instance_of(OneviewSDK::Enclosure).to receive(:save).and_return(true)
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return(true)
        allow_any_instance_of(OneviewSDK::Client).to receive(:response_handler).and_return(name: 'Encl1', serialNumber: 'Fake', uri: '/rest/fake')

        @data = {
          'name' => 'Fake-Enclosure',
          'hostname' => '1.1.1.1',
          'username' => 'Admin',
          'password' => 'secret123',
          'enclosureGroupUri' => '/rest/enclosure-groups/fake',
          'licensingIntent' => 'OneView',
          'force' => true
        }
        @enclosure = OneviewSDK::Enclosure.new(@client, @data)
      end

      it 'only sends certain attributes on the POST' do
        expect(@client).to receive(:rest_post).with('/rest/enclosures', { 'body' => @data.select { |k, _v| k != 'name' } }, anything)
        @enclosure.create
      end

      it 'sets the enclosure name correctly' do
        @enclosure.create
        expect(@enclosure[:name]).to eq('Fake-Enclosure')
      end

      it 'uses the given name if one is not specified' do
        @enclosure.data.delete('name')
        @enclosure.create
        expect(@enclosure[:name]).to eq('Encl1')
      end
    end

    context 'with invalid data' do
      it 'fails when certain attributes are not set' do
        enclosure = OneviewSDK::Enclosure.new(@client, {})
        expect { enclosure.create }.to raise_error(/Missing required attribute/)
      end
    end
  end

  describe '#refreshState' do
    context 'with invalid data' do
      it 'fails when invalid refreshState' do
        enclosure = OneviewSDK::Enclosure.new(@client, {})
        expect { enclosure.refreshState('None') }.to raise_error(/Invalid refreshState/)
      end
    end
  end
end
