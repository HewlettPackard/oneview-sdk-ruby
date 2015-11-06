require 'spec_helper'

RSpec.describe OneviewSDK::StorageSystem do
  include_context 'shared context'

  describe '#initialize' do
    context 'OneView 1.2' do
      it 'sets the defaults correctly' do
        profile = OneviewSDK::StorageSystem.new(@client_120)
        expect(profile[:type]).to eq('StorageSystemV2')
      end
    end

    context 'OneView 2.0' do
      it 'sets the defaults correctly' do
        profile = OneviewSDK::StorageSystem.new(@client)
        expect(profile[:type]).to eq('StorageSystemV3')
      end
    end
  end
end
