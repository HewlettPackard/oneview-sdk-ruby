require 'spec_helper'

RSpec.describe OneviewSDK::BulkEthernetNetwork do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::BulkEthernetNetwork.new(@client)
      expect(item[:type]).to eq('bulk-ethernet-network')
    end
  end

  describe 'validations' do
    it 'validates update' do
      expect { OneviewSDK::BulkEthernetNetwork.new(@client).update }.to raise_error(/Method not available for this resource!/)
    end

    it 'validates delete' do
      expect { OneviewSDK::BulkEthernetNetwork.new(@client).delete }.to raise_error(/Method not available for this resource!/)
    end

    it 'validates save' do
      expect { OneviewSDK::BulkEthernetNetwork.new(@client).save }.to raise_error(/Method not available for this resource!/)
    end

  end
end
