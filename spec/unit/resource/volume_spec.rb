require 'spec_helper'

RSpec.describe OneviewSDK::Volume do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      vol = OneviewSDK::Volume.new(@client)
      expect(vol[:provisioningParameters]).to eq({})
    end
  end


  describe '#validate' do
    vol = OneviewSDK::Volume.new(@client)
    it 'provision type' do
      expect(vol.set_provision_type('None')).to raise_error(/Invalid provision type/)
    end
  end

end
