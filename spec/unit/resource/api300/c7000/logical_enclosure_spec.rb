require 'spec_helper'

klass = OneviewSDK::API300::C7000::LogicalEnclosure
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

      it 'sets the /script uri' do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put).and_return(FakeResponse.new)
        expect(@client_300).to receive(:rest_put).with('/rest/logical-enclosures/fake/script', { 'body' => 'New' }, @client_300.api_version)
        @item.set_script('New')
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

    describe '#support_dump' do
      it 'calls the /support-dumps uri' do
        dump = { errorCode: 'FakeDump', encrypt: true, excludeApplianceDump: false }
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(FakeResponse.new)
        allow_any_instance_of(OneviewSDK::Client).to receive(:wait_for).and_return(true)
        expect(@client_300).to receive(:rest_post).with('/rest/logical-enclosures/fake/support-dumps', { 'body' => dump }, @client_300.api_version)
        @item.support_dump(dump)
      end

      it 'calls the /support-dumps uri' do
        dump = { errorCode: 'FakeDump', encrypt: false, excludeApplianceDump: false }
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(FakeResponse.new)
        allow_any_instance_of(OneviewSDK::Client).to receive(:wait_for).and_return(true)
        expect(@client_300).to receive(:rest_post).with('/rest/logical-enclosures/fake/support-dumps', { 'body' => dump }, @client_300.api_version)
        @item.support_dump(dump)
      end
    end
  end
end
