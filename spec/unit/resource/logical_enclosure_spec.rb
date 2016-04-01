require 'spec_helper'

RSpec.describe OneviewSDK::LogicalEnclosure do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 2.0' do
      it 'sets the type correctly' do
        template = OneviewSDK::LogicalEnclosure.new(@client)
        expect(template[:type]).to eq('LogicalEnclosure')
      end
    end
  end

  describe '#validate' do
    context 'valid values' do
      it 'allows valids fabricTypes' do
        logical_enclosure = OneviewSDK::LogicalEnclosure.new(@client)
        described_class::VALID_FABRIC_TYPES.each do |value|
          logical_enclosure[:fabricType] = value
          expect(logical_enclosure[:fabricType]).to eq(value)
        end
      end
    end

    context 'with invalid values' do
      it 'rejects an invalid fabricType' do
        logical_enclosure = OneviewSDK::LogicalEnclosure.new(@client)
        expect { logical_enclosure[:fabricType] = 'None' }.to raise_error.with_message(/Invalid fabric type/)
      end
    end
  end

  describe 'helper-methods' do
    before :each do
      @item = OneviewSDK::LogicalEnclosure.new(@client, uri: '/rest/logical-enclosures/fake')
    end

    describe '#reconfigure' do
      it 'calls the /configuration uri' do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put).and_return(FakeResponse.new)
        expect(@client).to receive(:rest_put).with('/rest/logical-enclosures/fake/configuration', {}, @client.api_version)
        @item.reconfigure
      end
    end

    describe '#update_from_group' do
      it 'calls the /updateFromGroup uri' do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put).and_return(FakeResponse.new)
        expect(@client).to receive(:rest_put).with('/rest/logical-enclosures/fake/updateFromGroup', {}, @client.api_version)
        @item.update_from_group
      end
    end

    describe '#get_script' do
      it 'calls the /script uri' do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new('Content'))
        expect(@client).to receive(:rest_get).with('/rest/logical-enclosures/fake/script', @client.api_version)
        expect(@item.get_script).to eq('Content')
      end
    end

    describe '#set_script' do
      it 'calls the /script uri' do
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_put).and_return(FakeResponse.new)
        expect(@client).to receive(:rest_put).with('/rest/logical-enclosures/fake/script', { 'body' => 'New' }, @client.api_version)
        @item.set_script('New')
      end
    end

    describe '#support_dump' do
      it 'calls the /support-dumps uri' do
        dump = { errorCode: 'FakeDump', encrypt: false, excludeApplianceDump: false }
        allow_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(FakeResponse.new)
        allow_any_instance_of(OneviewSDK::Client).to receive(:wait_for).and_return(true)
        expect(@client).to receive(:rest_post).with('/rest/logical-enclosures/fake/support-dumps', { 'body' => dump }, @client.api_version)
        @item.support_dump(dump)
      end
    end
  end
end
