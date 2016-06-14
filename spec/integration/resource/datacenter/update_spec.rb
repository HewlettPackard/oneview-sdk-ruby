require 'spec_helper'

RSpec.describe OneviewSDK::Datacenter, integration: true, type: UPDATE do
  include_context 'integration context'

  before :each do
    @item = OneviewSDK::Datacenter.find_by($client, name: DATACENTER1_NAME).first
  end

  describe '#update' do
    it 'Changes name' do
      @item.update(name: DATACENTER1_NAME_UPDATED)
      expect(@item[:name]).to eq(DATACENTER1_NAME_UPDATED)
      @item.refresh
      @item.update(name: DATACENTER1_NAME) # Put it back to normal
      expect(@item[:name]).to eq(DATACENTER1_NAME)
    end
  end
end
