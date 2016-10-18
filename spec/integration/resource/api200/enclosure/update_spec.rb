require 'spec_helper'

RSpec.describe OneviewSDK::Enclosure, integration: true, type: UPDATE do
  include_context 'integration context'

  before :each do
    @item = OneviewSDK::Enclosure.find_by($client, name: ENCL_NAME).first
  end

  describe '#update' do
    it 'Changes name' do
      @item.update(name: ENCL_NAME_UPDATED)
      expect(@item[:name]).to eq(ENCL_NAME_UPDATED)
      @item.update(name: ENCL_NAME) # Put it back to normal
      expect(@item[:name]).to eq(ENCL_NAME)
    end
  end

  describe '#configuration' do
    it 'update OneViewSDK_Int_Ethernet_Network name' do
      expect { @item.configuration }.not_to raise_error
    end
  end

  describe '#refreshState' do
    it 'returns all resources when the hash is empty' do
      expect { @item.set_refresh_state('RefreshPending') }.not_to raise_error
    end
  end
end
