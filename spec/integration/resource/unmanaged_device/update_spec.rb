require 'spec_helper'

RSpec.describe OneviewSDK::UnmanagedDevice, integration: true, type: UPDATE do
  include_context 'integration context'

  before :each do
    @item = OneviewSDK::UnmanagedDevice.new($client, name: UNMANAGED_DEVICE1_NAME)
    @item.retrieve!
  end

  describe '#update' do
    it 'Change name' do
      @item.update(name: 'UnmanagedDevice_1_Updated')
      @item.refresh
      expect(@item['name']).to eq('UnmanagedDevice_1_Updated')
      @item.update(name: UNMANAGED_DEVICE1_NAME)
    end
  end


end
