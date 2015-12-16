require 'spec_helper'

RSpec.describe OneviewSDK::Volume do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::Volume.new(@client, {})
      expect(item[:provisioningParameters]).to eq({})
    end
  end


  describe '#validate' do
    it 'provision type' do
      vol = OneviewSDK::Volume.new(@client, {})
      expect{vol.set_provision_type('N/A')}.to raise_error(/Invalid provision type/)
    end
  end

end
