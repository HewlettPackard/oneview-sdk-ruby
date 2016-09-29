require 'spec_helper'

RSpec.describe OneviewSDK::API300::Thunderbird::EnclosureGroup do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::EnclosureGroup
  end

  describe '#initialize' do
    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        item = OneviewSDK::API300::Thunderbird::EnclosureGroup.new(@client_300)
        expect(item[:type]).to eq('EnclosureGroupV200')
      end
    end
  end

  describe '#script' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::Thunderbird::EnclosureGroup.new(@client_300).get_script }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'gets uri/script' do
      item = OneviewSDK::API300::Thunderbird::EnclosureGroup.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with('/rest/fake/script', item.api_version).and_return(FakeResponse.new('Blah'))
      expect(@client_300.logger).to receive(:warn).with(/Failed to parse JSON response/).and_return(true)
      expect(item.get_script).to eq('Blah')
    end
  end

  describe '#set_script' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::Thunderbird::EnclosureGroup.new(@client_300).set_script('Blah') }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'does a PUT to uri/script' do
      item = OneviewSDK::API300::Thunderbird::EnclosureGroup.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_put).with('/rest/fake/script', { 'body' => 'Blah' }, item.api_version)
        .and_return(FakeResponse.new('Blah'))
      expect(@client_300.logger).to receive(:warn).with(/Failed to parse JSON response/).and_return(true)
      expect(item.set_script('Blah')).to eq(true)
    end
  end
end
