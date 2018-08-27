require 'spec_helper'

RSpec.describe OneviewSDK::API800::C7000::HypervisorManager do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::API800::C7000::HypervisorManager.new(@client_800)
      expect(item[:type]).to eq('HypervisorManagerV2')
      expect(item[:hypervisorType]).to eq('Vmware')
    end
  end
end
