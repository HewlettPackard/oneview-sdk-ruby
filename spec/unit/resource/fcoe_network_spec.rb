require 'spec_helper'

RSpec.describe OneviewSDK::FCoENetwork do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::FCoENetwork.new(@client)
      expect(item[:type]).to eq('fcoe-network')
      expect(item[:connectionTemplateUri]).to eq(nil)
    end
  end

  describe 'validations' do
    it 'validates vlanId' do
      options = { vlanId: 0 }
      expect { OneviewSDK::FCoENetwork.new(@client, options) }.to raise_error(/vlanId out of range/)
    end
  end
end
