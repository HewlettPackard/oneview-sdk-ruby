require 'spec_helper'

klass = OneviewSDK::API300::Synergy::LogicalEnclosure
extra_klass_1 = OneviewSDK::API300::Synergy::EnclosureGroup
extra_klass_2 = OneviewSDK::API300::Synergy::Enclosure
extra_klass_3 = OneviewSDK::API300::Synergy::FirmwareDriver
RSpec.describe klass do
  include_context 'shared context'

  let(:data) { [{ op: 'replace', path: '/name', value: {} }] }
  let(:response) { { 'key1' => 'val1', 'key2' => 'val2', 'key3' => { 'key4' => 'val4' } } }

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::LogicalEnclosure
  end

  describe 'helper-methods' do
    before :each do
      @item = klass.new(@client_300, uri: '/rest/logical-enclosures/fake')
    end

    describe '#reconfigure' do
      it 'calls the /configuration uri' do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put).and_return(FakeResponse.new)
        expect(@client_300).to receive(:rest_put).with('/rest/logical-enclosures/fake/configuration', {}, @client_300.api_version)
        @item.reconfigure
      end
    end

    describe '#update_from_group' do
      it 'calls the /updateFromGroup uri' do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put).and_return(FakeResponse.new)
        expect(@client_300).to receive(:rest_put).with('/rest/logical-enclosures/fake/updateFromGroup', {}, @client_300.api_version)
        @item.update_from_group
      end
    end

    describe '#update_firmware' do
      it 'requires a uri' do
        logical_enclosure = klass.new(@client_300)
        expect { logical_enclosure.update_firmware(:val) }
          .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
      end

      it 'updates the the firmware of a given logical enclosure' do
        data = { 'body' => [{ op: 'replace', path: '/firmware', value: 'val' }] }
        expect(@client_300).to receive(:rest_patch)
          .with('/rest/logical-enclosures/fake', data, @item.api_version).and_return(FakeResponse.new(key: 'Val'))
        expect(@item.update_firmware('val')).to eq('key' => 'Val')
      end
    end

    describe '#script' do
      it 'requires a uri' do
        expect { klass.new(@client_300).get_script }
          .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
      end

      it 'gets uri/script' do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new('Content'))
        expect(@client_300).to receive(:rest_get).with('/rest/logical-enclosures/fake/script', {}, @client_300.api_version)
        expect(@item.get_script).to eq('Content')
      end

      it 'returns method unavailable for the set_script method' do
        expect { @item.set_script }.to raise_error(/The method #set_script is unavailable for this resource/)
      end
    end

    describe '#support_dump' do
      it 'calls the /support-dumps uri' do
        dump = { errorCode: 'FakeDump', encrypt: false, excludeApplianceDump: false }
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(FakeResponse.new)
        allow_any_instance_of(OneviewSDK::Client).to receive(:wait_for).and_return(true)
        expect(@client_300).to receive(:rest_post).with('/rest/logical-enclosures/fake/support-dumps', { 'body' => dump }, @client_300.api_version)
        @item.support_dump(dump)
      end
    end

    describe '#set_enclosure_group' do
      before :each do
        @enclosure_group = extra_klass_1.new(@client_300, name: 'enclosure_group')
        @enclosure_group_uri = '/rest/fake/enclosure-groups/test'
      end

      it 'raising an exception when uri not exists' do
        expect(@client_300).to receive(:rest_get).with('/rest/enclosure-groups', {})
                                                 .and_return(FakeResponse.new)
        expect { @item.set_enclosure_group(@enclosure_group) }.to raise_error(/could not be found/)
      end

      it 'will set the enclosureGroupUri correctly' do
        @enclosure_group['uri'] = @enclosure_group_uri
        expect { @item.set_enclosure_group(@enclosure_group) }.to_not raise_error
        expect(@item['enclosureGroupUri']).to eq(@enclosure_group_uri)
      end

      it 'will fail to put enclosureGroupUri since the resource does not exists' do
        expect(@client_300).to receive(:rest_get).with('/rest/enclosure-groups', {})
                                                 .and_return(FakeResponse.new(members: [
              { name: 'wrong_enclosure_group', uri: 'wrong_uri' }
            ]))
        expect { @item.set_enclosure_group(@enclosure_group) }.to raise_error(/could not be found/)
      end
    end

    describe '#set_enclosure_uris' do
      before :each do
        @enclosure = extra_klass_2.new(@client_300, name: 'enclosure_group')
        @enclosure_uri = '/rest/fake/enclosures/test'
      end

      it 'raising an exception when uri not exists' do
        expect(@client_300).to receive(:rest_get).with('/rest/enclosures', {})
                                                 .and_return(FakeResponse.new)
        expect { @item.set_enclosures([@enclosure]) }.to raise_error(/could not be found/)
      end

      it 'raising an exception when uri list is empty' do
        expect { @item.set_enclosures }.to raise_error(/is empty/)
      end

      it 'will set the enclosureUris correctly' do
        @enclosure['uri'] = @enclosure_uri
        expect { @item.set_enclosures([@enclosure]) }.to_not raise_error
        expect(@item['enclosureUris'].size).to eq(1)
        expect(@item['enclosureUris'].first).to eq(@enclosure_uri)
      end

      it 'will set the enclosureUris with two enclosures correctly' do
        @enclosure['uri'] = @enclosure_uri
        enclosure2 = extra_klass_2.new(@client_300, name: 'enclosure_group2')
        enclosure2['uri'] = @enclosure_uri
        expect { @item.set_enclosures([@enclosure, enclosure2]) }.to_not raise_error
        expect(@item['enclosureUris'].size).to eq(2)
        expect(@item['enclosureUris']).to eq([@enclosure['uri'], enclosure2['uri']])
      end

      it 'will fail to put enclosureUri since the resource does not exists' do
        expect(@client_300).to receive(:rest_get).with('/rest/enclosures', {})
                                                 .and_return(FakeResponse.new(members: [
              { name: 'wrong_enclosure', uri: 'wrong_uri' }
            ]))
        expect { @item.set_enclosures([@enclosure]) }.to raise_error(/could not be found/)
      end
    end

    describe '#set_firmware_driver' do
      before :each do
        @firmware_driver = extra_klass_3.new(@client_300, name: 'firmware_driver')
        @firmware_driver_uri = '/rest/fake/firmware-drivers/test'
      end

      it 'raising an exception when uri not exists' do
        expect(@client_300).to receive(:rest_get).with('/rest/firmware-drivers', {})
                                                 .and_return(FakeResponse.new)
        expect { @item.set_firmware_driver(@firmware_driver) }.to raise_error(/could not be found/)
      end

      it 'will set the firmwareBaselineUri correctly' do
        @firmware_driver['uri'] = @firmware_driver_uri
        expect { @item.set_firmware_driver(@firmware_driver) }.to_not raise_error
        expect(@item['firmwareBaselineUri']).to eq(@firmware_driver_uri)
      end

      it 'will fail to put firmwareBaselineUri since the resource does not exists' do
        expect(@client_300).to receive(:rest_get).with('/rest/firmware-drivers', {})
                                                 .and_return(FakeResponse.new(members: [
              { name: 'wrong_enclosure_group', uri: 'wrong_uri' }
            ]))
        expect { @item.set_firmware_driver(@firmware_driver) }.to raise_error(/could not be found/)
      end
    end
  end
end
