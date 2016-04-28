require 'spec_helper'

RSpec.describe OneviewSDK::BulkEthernetNetwork do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::BulkEthernetNetwork.new(@client)
      expect(item[:type]).to eq('bulk-ethernet-network')
    end
  end

  describe '#create' do
    let(:options) do
      {
        vlanIdRange: '26-50',
        purpose: 'General',
        namePrefix: 'OneViewSDK_Bulk_Network'
      }
    end
    it 'returns true' do
      item = OneviewSDK::BulkEthernetNetwork.new(@client, options)
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_api).and_return(FakeResponse.new({}, 202))
      expect_any_instance_of(OneviewSDK::Client).to receive(:wait_for).and_return({})
      expect(item.create).to eq(true)
    end
  end

  describe 'undefined methods' do
    before :each do
      @item = OneviewSDK::BulkEthernetNetwork.new(@client)
    end

    it 'does not allow the update action' do
      expect { @item.update }.to raise_error(/Method not available for this resource!/)
    end

    it 'does not allow the delete action' do
      expect { @item.delete }.to raise_error(/Method not available for this resource!/)
    end

  end
end
